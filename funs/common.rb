require 'pry'
require 'benchmark'
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

