class User < ActiveRecord::Base

  self.per_page = 5

  #:omniauthable
  #:token_authenticatable
  #:confirmable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable, :timeoutable

  # just am example to filter
  # scope :user_filter, lambda {|user_id|
  #  where(:id => user_id) unless user_id.nil?
  #}

  # Setup accessible (or protected) attributes for your model
  belongs_to :user_type
  has_and_belongs_to_many :roles
  belongs_to :state, :class_name => 'State', :foreign_key => 'state_id'
  belongs_to :org_state, :class_name => 'State', :foreign_key => 'org_state_id'
  has_many :projects


  attr_accessible :username, :email, :password, :password_confirmation, :user_type_id, :remember_me, :first_name, :last_name, :phone, :street1, :street2, :city, :state_id, :zip, :org_name, :job_title, :org_street1, :org_street2, :org_city, :org_state_id, :org_zip
  attr_accessible :role_ids, :approved, :deleted, :deleted_at, :username, :email, :password, :password_confirmation, :user_type_id, :remember_me, :first_name, :last_name, :phone, :street1, :street2, :city, :state_id, :zip, :org_name, :job_title, :org_street1, :org_street2, :org_city, :org_state_id, :org_zip,  :as => :admin

  validates :username,:email, :user_type_id, :first_name, :last_name, :phone, :roles, :presence => true

  #before_save :set_default
  after_create :default_role


  def deleted
     !deleted_at.nil?
  end

  def deleted=(isDeleted)
    self.deleted_at = (isDeleted=='true') ? Time.current : nil
  end

 # def set_default
 #   set_default = false unless  :set_default
 # end

  def default_role
    self.roles << Role.find_by_name('Basic User')
  end

  # the account needs to be approved by an administrator
  def active_for_authentication?
    super && !deleted && approved?
  end

  def inactive_message
    if !approved?
      :not_approved
    elsif deleted
      :deleted
    else
      super # Use whatever other message
    end
  end

#   def self.send_reset_password_instructions(attributes={})
#     recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
#     if !recoverable.approved?
#       recoverable.errors[:base] << I18n.t("devise.failure.not_approved")
#     elsif recoverable.persisted?
#       recoverable.send_reset_password_instructions
#     end
#     recoverable
#   end

  # allow updates without entering current password
  def update_with_password(params={})
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end
    update_attributes(params)
  end

  # delete user
  def soft_delete
    update_attribute(:deleted_at, Time.current)
  end

  def destroy
    self.soft_delete
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_navigational_format?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  def role?(role)
    return !!self.roles.find_by_name(role.to_s.titleize)
  end

  def self.searchByStatus(status)
    scoped = self.scoped
    if status
    scoped = scoped.where(:approved => true, :deleted_at => nil).order("updated_at desc") if status=='approved'
    scoped = scoped.where(:approved => false, :deleted_at => nil).order("updated_at desc") if status=='notapproved'
    scoped = scoped.where("deleted_at IS NOT NULL") if status=='deleted'
    end
      scoped

  end

  def self.search(search)
    if search
      where('username LIKE ? OR email LIKE ? OR last_name LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%")
      # find(:all, :conditions => ['title LIKE ? OR description LIKE ?', search_condition, search_condition])
    else
      scoped
    end
  end

  #def self.all_enabled(par = nil)
  #  if par.nil?
  #    scoped
  #  elsif par == 'true'
  #    where(:deleted_at => nil)
  #  else    par == 'false'
  #         where("deleted_at IS NOT NULL")
  #  end
  #end
end
