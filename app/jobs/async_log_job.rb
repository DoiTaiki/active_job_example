class AsyncLogJob < ApplicationJob
  queue_as :async_log

  def perform(message: "hello") #message引数を追加
    AsyncLog.create!(message: message) #DBに保存する
  end

  retry_on StandardError, wait: 5.seconds, attempts: 3
  retry_on ArgumentError, ZeroDivisionError, wait: 5.seconds, attempts: 3
  discard_on StandardError do |job, error|
    SomeNotifier.push(error)
  end
end
