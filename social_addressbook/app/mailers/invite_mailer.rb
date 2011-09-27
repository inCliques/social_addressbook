class InviteMailer < ActionMailer::Base
  default :from => "info@cliequ.es"

  def send_invitation(inviter, invitee, group)
    @link = new_user_registration_url+'?email='+invitee.email
    @inviter = inviter
    @invitee = invitee
    @group = group
    if inviter.name.nil?
      subject = "You got invited to join the "+group.name+" clique"
    else
      subject = inviter.name+" invites you to join the "+group.name+" clique"
    end
    mail(:to => invitee.email, :subject => subject)  
  end  
end
