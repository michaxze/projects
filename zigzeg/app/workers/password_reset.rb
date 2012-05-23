class PasswordReset
  @queue = :passwordreset_queue

  def self.perform(user_id, confirmation_id)
    puts "Preparing to send password reset email..."
    user = User.find(user_id)
    confirmation = Confirmation.find(confirmation_id)

    unless user.nil?
        Mailer.forget_password_instructions(user, confirmation).deliver
    end
  end
end
