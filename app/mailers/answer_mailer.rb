class AnswerMailer < ApplicationMailer
  # To generate a mailer, do:
  # rails g mailer <name-of-mailer>

  # In a mailer class, the public methods are used to
  # create and send mail. They're similar to actions in
  # a controller.

  # To read more about mailers:
  # https://guides.rubyonrails.org/action_mailer_basics.html

  # To deliver this mail, do the following:
  # AnswerMailer.hello_world.deliver_now
  def hello_world
    mail(
      to: "brett@codecore.ca",
      from: "info@awesome-answers.io",
      cc: "ian@codecore.ca",
      bcc: "someone.else@example.com",
      subject: "Hello, World!"
    )
  end

  def new_answer(answer)
    # Any instance variable set in a mailer
    # will be available in its rendered template.
    @answer = answer
    @question = answer.question
    @question_owner = @question.user
    mail(
      to: @question_owner.email,
      subject: "#{@answer.user.first_name} answered your question!"
    )
  end
end
