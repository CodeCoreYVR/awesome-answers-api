# To generate the migration for delayed_job's queue, run:
# rails g delayed_job:active_record

# To generate a job file, run:
# rails g job <job-name>

# To start a worker to run jobs from your queue, run
# (in a separate tab):
# rails jobs:work
class HelloWorldJob < ApplicationJob
  queue_as :default

  # When a job is executed, the perform method will be
  # called
  def perform(*args)
    puts "--------------------"
    puts "Running a super awesome job"
    puts "--------------------"
    puts "this one right here."
  end

  # To run a job, use any of the following methods

  # <JobClass>.perform_now(<args>)
  # This will run the job synchronously (or in the
  # foreground) meaning that it will not be in the
  # queue. If it is called from Rails, Rails would
  # execute the job instead of a worker.

  # <JobClass>.perform_later(<args>)
  # This will insert the job in your queue to be executed
  # by a worker.

  # To perform jobs at a given time, use the set method:
  # <JobClass>.set(<some-kind-of-time>)

  # HelloWorld.set(wait: 10.minutes).perform_later
  # ^ The above will insert a job into the queue that
  # will only run after 10 minutes have elapsed.

  # Another example:
  # HelloWorldJob.set(run_at: 1.week.from_now).perform_later

  # To see more options, check out the documentation at:
  # http://guides.rubyonrails.org/active_job_basics.html
end
