class InviteMailer < ActionMailer::Base
  default :from => "info@cliequ.es"

  def send_invitation(inviter, group, email)
    @link = new_user_registration_url+'?email='+email
    @inviter = inviter
    @group = group
    @email = email
    if inviter.name.nil?
      subject = "You got invited to join the "+group.name+" clique"
    else
      subject = inviter.name+" invites you to join the "+group.name+" clique"
    end
    mail(:to => email, :subject => subject)  
  end  
end
