puts "g returned: #{g}"
 
# Note that the return inside the "Proc.new" didn't just return from the Proc -- it returned
# all the way out of g, bypassing not only the rest of g but the rest of f as well! It worked
# almost like an exception.
#
# This means that it's not possible to call a Proc containing a "return" when the creating
# context no longer exists:
 
example 12
 
def make_proc_new
  begin
      Proc.new { return "Value from Proc.new" } # this "return" will return from make_proc_new
  ensure
      puts "make_proc_new exited"
  end
end
 
begin
  puts make_proc_new.call
rescue Exception => e
  puts "Failed with #{e.class}: #{e}"
end
 
# (Note that this makes it unsafe to pass Procs across threads.)
 
# A Proc.new, then, is not quite truly closed: it depends on the creating context still existing,
# because the "return" is tied to that context.
#
# Not so for lambda:
 
example 13
 
def g
  result = f(lambda { return "Value from lambda" })
  puts "f returned: " + result
  "Value from g"
end
 
puts "g returned: #{g}"
 
# And yes, you can call a lambda even when the creating context is gone:
 
example 14
 
def make_lambda
  begin
      lambda { return "Value from lambda" }
  ensure
      puts "make_lambda exited"
  end
end
 
puts make_lambda.call
 
# Inside a lambda, a return statement only returns from the lambda, and flow continues normally.
# So a lambda is like a function unto itself, whereas a Proc remains dependent on the control
# flow of its caller.
#
# A lambda, therefore, is Ruby's true closure.
#
# As it turns out, "proc" is a synonym for either "Proc.new" or "lambda."
# Anybody want to guess which one? (Hint: "Proc" in lowercase is "proc.")
 
example 15
 
def g
  result = f(proc { return "Value from proc" })
  puts "f returned: " + result
  "Value from g"
end
 
puts "g returned: #{g}"
 
# Hah. Fooled you.
#
# The answer: Ruby changed its mind. If you're using Ruby 1.8, it's a synonym for "lambda."
# That's surprising (and also ridiculous); somebody figured this out, so in 1.9, it's a synonym for
# Proc.new. Go figure.
 
# I'll spare you the rest of the experiments, and give you the behavior of all 7 cases:
#
# "return" returns from caller:
#      1. block (called with yield)
#      2. block (&b  =>  f(&b)  =>  yield)  
#      3. block (&b  =>  b.call)    
#      4. Proc.new
#      5. proc in 1.9
#
# "return" only returns from closure:
#      5. proc in 1.8
#      6. lambda    
#      7. method
 
# ---------------------------- Section 4: Closures and Arity ----------------------------
 
# The other major distinguishing of different kinds of Ruby closures is how they handle mismatched
# arity -- in other words, the wrong number of arguments.
#
# In addition to "call," every closure has an "arity" method which returns the number of expected
# arguments:
 
example 16
 
puts "One-arg lambda:"
puts (lambda {|x|}.arity)
puts "Three-arg lambda:"
puts (lambda {|x,y,z|}.arity)
 
# ...well, sort of:
 
puts "No-args lambda: "
puts (lambda {}.arity) # This behavior is also subject to change in 1.9.
puts "Varargs lambda: "
puts (lambda {|*args|}.arity)
 
# Watch what happens when we call these with the wrong number of arguments:
 
example 17
 
def call_with_too_many_args(closure)
  begin
      puts "closure arity: #{closure.arity}"
      closure.call(1,2,3,4,5,6)
      puts "Too many args worked"
  rescue Exception => e
      puts "Too many args threw exception #{e.class}: #{e}"
  end
end
 
def two_arg_method(x,y)
end
 
# puts; puts "Proc.new:"; call_with_too_many_args(Proc.new {|x,y|})
# puts; puts "proc:"    ; call_with_too_many_args(proc {|x,y|})
# puts; puts "lambda:"  ; call_with_too_many_args(lambda {|x,y|})
# puts; puts "Method:"  ; call_with_too_many_args(method(:two_arg_method))
 
def call_with_too_few_args(closure)
  begin
    puts "closure arity: #{closure.arity}"
    closure.call()
    puts "Too few args worked"
  rescue Exception => e
    puts "Too few args threw exception #{e.class}: #{e}"
  end
end
 
# puts; puts "Proc.new:"; call_with_too_few_args(Proc.new {|x,y|})
# puts; puts "proc:"    ; call_with_too_few_args(proc {|x,y|})
# puts; puts "lambda:"  ; call_with_too_few_args(lambda {|x,y|})
# puts; puts "Method:"  ; call_with_too_few_args(method(:two_arg_method))
 
# Yet oddly, the behavior for one-argument closures is different....
 
example 18
 
def one_arg_method(x)
end
 
# puts; puts "Proc.new:"; call_with_too_many_args(Proc.new {|x|})
# puts; puts "proc:"    ; call_with_too_many_args(proc {|x|})
# puts; puts "lambda:"  ; call_with_too_many_args(lambda {|x|})
# puts; puts "Method:"  ; call_with_too_many_args(method(:one_arg_method))
# puts; puts "Proc.new:"; call_with_too_few_args(Proc.new {|x|})
# puts; puts "proc:"    ; call_with_too_few_args(proc {|x|})
# puts; puts "lambda:"  ; call_with_too_few_args(lambda {|x|})
# puts; puts "Method:"  ; call_with_too_few_args(method(:one_arg_method))
 
# Yet when there are no args...
 
example 19
 
def no_arg_method
end
 
# puts; puts "Proc.new:"; call_with_too_many_args(Proc.new {||})
# puts; puts "proc:"    ; call_with_too_many_args(proc {||})
# puts; puts "lambda:"  ; call_with_too_many_args(lambda {||})
# puts; puts "Method:"  ; call_with_too_many_args(method(:no_arg_method))
 
# For no good reason that I can see, Proc.new, proc and lambda treat a single argument as a special
# case; only a method enforces arity in all cases. Principle of least surprise my ass.
 
 
 
# ---------------------------- Section 5: Rant ----------------------------
#
# This is quite a dizzing array of syntactic options, with subtle semantics differences that are not
# at all obvious, and riddled with minor special cases. It's like a big bear trap from programmers who
# expect the language to just work.
#
# Why are things this way? Because Ruby is:
#
#   (1) designed by implementation, and
#   (2) defined by implementation.
#
# The language grows because the Ruby team tacks on cool ideas, without maintaining a real spec apart
# from CRuby. A spec would make clear the logical structure of the language, and thus help highlight
# inconsistencies like the ones we've just seen. Instead, these inconsinstencies creep into the language,
# confuse the crap out of poor souls like me who are trying to learn it, and then get submitted as bug
# reports. Something as fundamental as the semantics of proc should not get so screwed up that they have
# to backtrack between releases, for heaven's sake! Yes, I know, language design is hard -- but something
# like this proc/lambda issue or the arity problem wasn't so hard to get right the first time.
# Yammer yammer.
 
 
# ---------------------------- Section 6: Summary ----------------------------
#
# So, what's the final verdict on those 7 closure-like entities?          
#
#                                                     "return" returns from closure
#                                    True closure?    or declaring context...?         Arity check?
#                                    ---------------  -----------------------------    -------------------
# 1. block (called with yield)       N                declaring                        no
# 2. block (&b => f(&b) => yield)    N                declaring                        no
# 3. block (&b => b.call)            Y except return  declaring                        warn on too few
# 4. Proc.new                        Y except return  declaring                        warn on too few
# 5. proc                                    <<< alias for lambda in 1.8, Proc.new in 1.9 >>>
# 6. lambda                          Y                closure                          yes, except arity 1
# 7. method                          Y                closure                          yes
#
# The things within each of these groups are all semantically identical -- that is, they're different
# syntaxes for the same thing:
#   
#      1. block (called with yield)
#      2. block (&b  =>  f(&b)  =>  yield)  
#      -------
#      3. block (&b  =>  b.call)
#      4. Proc.new  
#      5. proc in 1.9
#      -------
#      5. proc in 1.8
#      6. lambda    
#      -------
#      7. method (may be identical to lambda with changes to arity checking in 1.9)
#
# Or at least, this is how I *think* it is, based on experiment. There's no authoritative answer other
# than testing the CRuby implementation, because there's no real spec -- so there may be other differences
# I haven't discovered.
#
# The final verdict: Ruby has four types of closures and near-closures, expressible in seven syntactic
# variants. Not pretty. But you sure sure do cool stuff with them! That's up next....
#
# This concludes the "Ruby makes Paul crazy" portion of our broadcast; from here on, it will be the "Ruby is
# awesome" portion.
 
 
# ---------------------------- Section 7: Doing Something Cool with Closures ----------------------------
 
# Let's make a data structure containing all of the Fibonacci numbers. Yes, I said *all* of them.
# How is this possible? We'll use closures to do lazy evaluation, so that the computer only calculates
# as much of the list as we ask for.
 
# To make this work, we're going to use Lisp-style lists: a list is a recursive data structure with
# two parts: "car," the next element of the list, and "cdr," the remainder of the list.
#
# For example, the list of the first three positive integers is [1,[2,[3]]]. Why? Because:
#
#   [1,[2,[3]]]     <--- car=1, cdr=[2,[3]]
#      [2,[3]]      <--- car=2, cdr=[3]
#         [3]       <--- car=3, cdr=nil
#
# Here's a class for traversing such lists:
 
example 20
 
class LispyEnumerable
  include Enumerable
 
  def initialize(tree)
    @tree = tree
  end
 
  def each
    while @tree
      car,cdr = @tree
      yield car
      @tree = cdr
    end
  end
end
 
list = [1,[2,[3]]]
LispyEnumerable.new(list).each do |x|
  puts x
end
 
# So how to make an infinite list? Instead of making each node in the list a fully built
# data structure, we'll make it a closure -- and then we won't call that closure
# until we actually need the value. This applies recursively: the top of the tree is a closure,
# and its cdr is a closure, and the cdr's cdr is a closure....
 
example 21
 
class LazyLispyEnumerable
  include Enumerable
 
  def initialize(tree)
      @tree = tree
  end
 
  def each
      while @tree
          car,cdr = @tree.call # <--- @tree is a closure
          yield car
          @tree = cdr
      end
  end
end
 
list = lambda{[1, lambda {[2, lambda {[3]}]}]} # same as above, except we wrap each level in a lambda
LazyLispyEnumerable.new(list).each do |x|
  puts x
end
 
example 22
 
# Let's see when each of those blocks gets called:
list = lambda do
  puts "first lambda called"
  [1, lambda do
    puts "second lambda called"
    [2, lambda do
      puts "third lambda called"
      [3]
    end]
  end]
end
 
puts "List created; about to iterate:"
LazyLispyEnumerable.new(list).each do |x|
  puts x
end
 
 
# Now, because the lambda defers evaluation, we can make an infinite list:
 
example 23
 
def fibo(a,b)
  lambda { [a, fibo(b,a+b)] } # <---- this would go into infinite recursion if it weren't in a lambda
end
 
LazyLispyEnumerable.new(fibo(1,1)).each do |x|
  puts x
  break if x > 100 # we don't actually want to print all of the Fibonaccis!
end
 
# This kind of deferred execution is called "lazy evaluation" -- as opposed to the "eager
# evaluation" we're used to, where we evaluate an expression before passing its value on.
# (Most languages, including Ruby, use eager evaluation, but there are languages (like Haskell)
# which use lazy evaluation for everything, by default! Not always performant, but ever so very cool.)
#
# This way of implementing lazy evaluation is terribly clunky! We had to write a separate
# LazyLispyEnumerable that *knows* we're passing it a special lazy data structure. How unsatisfying!
# Wouldn't it be nice of the lazy evaluation were invisible to callers of the lazy object?
#
# As it turns out, we can do this. We'll define a class called "Lazy," which takes a block, turns it
# into a closure, and holds onto it without immediately calling it. The first time somebody calls a
# method, we evaluate the closure and then forward the method call on to the closure's result.
 
class Lazy
  def initialize(&generator)
  @generator = generator
  end
 
  def method_missing(method, *args, &block)
    evaluate.send(method, *args, &block)
  end
 
  def evaluate
    @value = @generator.call unless @value
    @value
  end
end
 
def lazy(&b)
  Lazy.new &b
end
 
# This basically allows us to say:
#
#   lazy {value}
# 
# ...and get an object that *looks* exactly like value -- except that value won't be created until the
# first method call that touches it. It creates a transparent lazy proxy object. Observe:
 
example 24
 
x = lazy do
  puts "<<< Evaluating lazy value >>>"
  "lazy value"
end
 
puts "x has now been assigned"
puts "About to call one of x's methods:"
puts "x.size: #{x.size}"          # <--- .size triggers lazy evaluation
puts "x.swapcase: #{x.swapcase}"
 
# So now, if we define fibo using lazy instead of lambda, it should magically work with our
# original LispyEnumerable -- which has no idea it's dealing with a lazy value! Right?
 
example 25
 
def fibo(a,b)
  lazy { [a, fibo(b,a+b)] }
end
 
LispyEnumerable.new(fibo(1,1)).each_with_index do |x|
  puts x
  break if x > 100 # we don't actually want to print all of the Fibonaccis!
end
 
# Oops! If you're using Ruby 1.8, that didn't work. What went wrong?
#
# The failure started in this line of LispyEnumerable (though Ruby didn't report the error there):
#
#      car,cdr = @tree
#
# Let's zoom in on that result, and see what happened:
 
example 26
 
car,cdr = fibo(1,1)
puts "car=#{car}  cdr=#{cdr}"
 
# Here's the problem. When we do this:
#
#   x,y = z
#
# ...Ruby calls z.respond_to?(to_a) to see if z is an array. If it is, it will do the multiple
# assignment; if not, it will just assign x=z and set y=nil.
#
# We want our Lazy to forward the respond_to? call to our fibo list. But it doesn't forward it,
# because we used the method_missing to do the proxying -- and every object implements respond_to?
# by default, so the method isn't missing! The respond_to? doesn't get forwarded; instead, out Lazy
# says "No, I don't respond to to_a; thanks for asking." The immediate solution is to forward
# respond_to? manually:
 
class Lazy
  def initialize(&generator)
  @generator = generator
  end
 
  def method_missing(method, *args, &block)
  evaluate.send(method, *args, &block)
  end
 
  def respond_to?(method)
    evaluate.respond_to?(method)
  end
 
  def evaluate
    @value = @generator.call unless @value
    @value
  end
end
 
# And *now* our original Lispy enum can work:
 
example 27
 
LispyEnumerable.new(fibo(1,1)).each do |x|
  puts x
  break if x > 200
end

