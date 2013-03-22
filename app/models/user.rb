class User < ActiveRecord::Base
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
  has_many :projects
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :deleted_at
  attr_accessible :approved     # TODO: for admin only
  # attr_accessible :title, :body

  before_save :set_default

  def set_default
    set_default = false unless  :set_default
  end

  # the account needs to be approved by an administrator
  def active_for_authentication?
    super && !deleted_at && approved?
  end

  def inactive_message
    if !approved?
      :not_approved
    elsif deleted_at
      :deleted
    else
      super # Use whatever other message
    end
  end

  def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if !recoverable.approved?
      recoverable.errors[:base] << I18n.t("devise.failure.not_approved")
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end

  def soft_delete
    update_attribute(:deleted_at, Time.current)
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
      where 'email LIKE ?', "%#{search}%"
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
