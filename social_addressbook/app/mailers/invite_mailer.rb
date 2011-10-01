class InviteMailer < ActionMailer::Base
  default :from => "no-reply@incliqu.es"

  def send_invitation(inviter, invitee, group)
    @link = new_user_registration_url+'?email='+invitee.email
    @inviter = inviter
    name_data_type_id = DataType.first(:conditions => { :name => 'Name' }).id
    @inviter_name = @inviter.user_data.first(:all, :conditions => {:data_type_id => name_data_type_id}).value
    @invitee = invitee
    @group = group

    subject = @inviter_name+" invites you to join the "+group.name+" clique"
    mail(:to => invitee.email, :subject => subject)  
  end  
end
