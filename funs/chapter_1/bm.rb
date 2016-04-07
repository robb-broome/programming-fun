require 'benchmark'
require 'pry'
def bm(times =1)
  runtime = 0
  ans = []
  times.times do
    runtime += Benchmark.realtime do
      ans = yield
      # puts yield.join(',')
    end
  end
  time = (runtime / times * 1_000_000).round( 2 )
  [ans, time]
  # time = time.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  # puts ""
  # puts  time + " microseconds. (n=#{times})"
end

def ar n
  array = []
  space = 100
  rndm = Random.new
  try = 0
  loop do
    break if array.size == n
    array << try = rndm.rand( (try + 1)..(try + space) )
  end
  array
end

def arsim n, technique = [:slow, :fast]
  a = ar(n)
  b = ar(n)
  c = a.dup
  d = b.dup

  # puts "a is #{a.join(',')}"
  # puts "b is #{b.join(',')}"
  puts "setup complete"

  run1_result, run1_time = bm {slow(a, b)} if technique.include? :slow
  run2_result, run2_time = bm {fast(c, d)} if technique.include? :fast

  if run1_result != run2_result
    puts 'answers did not match'
    puts run1_result.inspect if technique.include? :slow
    puts run2_result.inspect if technique.include? :fast
    puts run1_result - run2_result if technique.include?(:slow) & technique.include?(:fast)
  end
if technique.include?(:slow) & technique.include?(:fast)
  [run1_time, run2_time, (run1_time/run2_time).round(0)]
else
  run2_time
end
end

def slow a, b
  [].tap do |shared|
    loop do
      break unless a_val = a.shift
      # STDOUT.write "\r#{a_val}"
      shared << a_val if b.include?(a_val)
    end
  end
end

def fast a, b
  shared = []
  b_val = b.shift
  loop do
    break unless a_val = a.shift
    loop do
      case a_val <=> b_val
      when nil
        break
      when -1
        # B is bigger, try the next a
        break
      when 0
        # equal, use the b value, go to next a and b
        shared << b_val
        b_val = b.shift
        break
      when 1
        # a is bigger, so, don't change a but go to the next b
        b_val = b.shift
      end
    end
  end
  shared
end
