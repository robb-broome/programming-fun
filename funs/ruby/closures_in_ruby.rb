# README
# The base for this file is copied from
# https://innig.net/software/ruby/closures-in-ruby
# and is used here as a basis for practice.
#
# CLOSURES IN RUBY     Paul Cantrell    https://innig.net
# Email: username "cantrell", domain name "pobox.com"
 
# I recommend executing this file, then reading it alongside its output.
#
# Alteratively, you can give yourself a sort of Ruby test by deleting all the comments,
# then trying to guess the output of the code!
 
# A closure is a block of code which meets three criteria:
# 
#     * It can be passed around as a value and
# 
#     * executed on demand by anyone who has that value, at which time
# 
#     * it can refer to variables from the context in which it was created
#       (i.e. it is closed with respect to variable access, in the
#       mathematical sense of the word "closed").
#
# (The word "closure" actually has an imprecise meaning, and some people don't
# think that criterion #1 is part of the definition. I think it is.)
# 
# Closures are a mainstay of functional languages, but are present in many other
# languages as well (e.g. Java's anonymous inner classes). You can do cool stuff
# with them: they allow deferred execution, and some elegant tricks of style.
# 
# Ruby is based on the "principle of least surprise," but I had a really nasty
# surprise in my learning process. When I understood what methods like "each"
# were doing, I thought, "Aha! Ruby has closures!" But then I found out that a
# function can't accept multiple blocks -- violating the principle that closures
# can be passed around freely as values.
# 
# This document details what I learned in my quest to figure out what the deal is.
def example num
  puts
  puts "------ Example #{num} ------"
end

# ---------------------------- Section 1: Blocks ----------------------------

# Blocks are like closures, because they can refer to variables from their defining context:

example 1

def thrice
yield
yield
yield
end

x = 5
puts "value of x before: #{x}"
thrice { x += 1 }
puts "value of x after: #{x}"

# A block refers to variables in the context it was defined, not the context in which it is called:

example 2

def thrice_with_local_x
x = 100
yield
yield
yield
puts "value of x at end of thrice_with_local_x: #{x}"
end

x = 5
thrice_with_local_x { x += 1 }
puts "value of outer x after: #{x}"

# A block only refers to *existing* variables in the outer context; if they don't exist in the outer, a
# block won't create them there:

example 3

thrice do # note that {...} and do...end are completely equivalent
y = 10
puts "Is y defined inside the block where it is first set?"
puts "Yes." if defined? y
end
puts "Is y defined in the outer context after being set in the block?"
puts "No!" unless defined? y

# OK, so blocks seem to be like closures: they are closed with respect to variables defined in the context
# where they were created, regardless of the context in which they're called.
# 
# But they're not quite closures as we've been using them, because we have no way to pass them around:
# "yield" can *only* refer to the block passed to the method it's in.
#
# We can pass a block on down the chain, however, using &:

example 4

def six_times(&block)
thrice(&block)
thrice(&block)
end

x = 4
six_times { x += 10 }
puts "value of x after: #{x}"

# So do we have closures? Not quite! We can't hold on to a &block and call it later at an arbitrary
# time; it doesn't work. This, for example, will not compile:
#
# def save_block_for_later(&block)
#     saved = &block
# end
#
# But we *can* pass it around if we use drop the &, and use block.call(...) instead of yield:

example 5

def save_for_later(&b)
@saved = b  # Note: no ampersand! This turns a block into a closure of sorts.
end

save_for_later { puts "Hello!" }
puts "Deferred execution of a block:"
@saved.call
@saved.call

# But wait! We can't pass multiple blocks to a function! As it turns out, there can be only zero
# or one &block_params to a function, and the &param *must* be the last in the list.
#
# None of these will compile:
#
#    def f(&block1, &block2) ...
#    def f(&block1, arg_after_block) ...
#    f { puts "block1" } { puts "block2" }
#
# What the heck?
#
# I claim this single-block limitation violates the "principle of least surprise." The reasons for
# it have to do with ease of C implementation, not semantics.
#
# So: are we screwed for ever doing anything robust and interesting with closures?


# ---------------------------- Section 2: Closure-Like Ruby Constructs ----------------------------

# Actually, no. When we pass a block &param, then refer to that param without the ampersand, that
# is secretly a synonym for Proc.new(&param):

example 6

def save_for_later(&b)
@saved = Proc.new(&b) # same as: @saved = b
end

save_for_later { puts "Hello again!" }
puts "Deferred execution of a Proc works just the same with Proc.new:"
@saved.call

# We can define a Proc on the spot, no need for the &param:

example 7

@saved_proc_new = Proc.new { puts "I'm declared on the spot with Proc.new." }
puts "Deferred execution of a Proc works just the same with ad-hoc Proc.new:"
@saved_proc_new.call

# Behold! A true closure!
#
# But wait, there's more.... Ruby has a whole bunch of things that seem to behave like closures,
# and can be called with .call:

example 8

@saved_proc_new = Proc.new { puts "I'm declared with Proc.new." }
@saved_proc = proc { puts "I'm declared with proc." }
@saved_lambda = lambda { puts "I'm declared with lambda." }
def some_method 
puts "I'm declared as a method."
end
@method_as_closure = method(:some_method)
 
puts "Here are four superficially identical forms of deferred execution:"
@saved_proc_new.call
@saved_proc.call
@saved_lambda.call
@method_as_closure.call
 
# So in fact, there are no less than seven -- count 'em, SEVEN -- different closure-like constructs in Ruby:
#
#      1. block (implicitly passed, called with yield)
#      2. block (&b  =>  f(&b)  =>  yield)  
#      3. block (&b  =>  b.call)    
#      4. Proc.new  
#      5. proc  
#      6. lambda    
#      7. method
#
# Though they all look different, some of these are secretly identical, as we'll see shortly.
#
# We already know that (1) and (2) are not really closures -- and they are, in fact, exactly the same thing.
# Numbers 3-7 all seem to be identical. Are they just different syntaxes for identical semantics?
 
# ---------------------------- Section 3: Closures and Control Flow ----------------------------
 
# No, they aren't! One of the distinguishing features has to do with what "return" does.
#
# Consider first this example of several different closure-like things *without* a return statement.
# They all behave identically:
 
example 9
 
def f(closure)
puts
puts "About to call closure"
result = closure.call
puts "Closure returned: #{result}"
"Value from f"
end
 
puts "f returned: " + f(Proc.new { "Value from Proc.new" })
puts "f returned: " + f(proc { "Value from proc" })
puts "f returned: " + f(lambda { "Value from lambda" })
def another_method
"Value from method"
end
puts "f returned: " + f(method(:another_method))
 
# But put in a "return," and all hell breaks loose!
 
example 10
 
begin
f(Proc.new { return "Value from Proc.new" })
rescue Exception => e
puts "Failed with #{e.class}: #{e}"
end
 
# The call fails because that "return" needs to be inside a function, and a Proc isn't really
# quite a full-fledged function:
 
example 11
 
def g
result = f(Proc.new { return "Value from Proc.new" })
puts "f returned: " + result # never executed
"Value from g"               # never executed
end
 
