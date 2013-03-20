class User < ActiveRecord::Base
  #:omniauthable
  #:token_authenticatable
  #:confirmable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable, :timeoutable

  scope :enabled, where(:deleted_at => nil)
  scope :disabled, where("deleted_at IS NOT NULL")

  # just am example to filter
  scope :user_filter, lambda {|user_id|
    where(:id => user_id) unless user_id.nil?
  }

  scope :is_enabled_filter, lambda {|par|
    where(:is_enabled => par) unless par.nil?
  }

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :deleted_at
  # attr_accessible :title, :body

  # the account needs to be approved by an administrator
  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    if !approved?
      :not_approved
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

  def self.search(search)
    if search
      where 'email LIKE ?', "%#{search}%"
      # find(:all, :conditions => ['title LIKE ? OR description LIKE ?', search_condition, search_condition])
    else
      scoped
    end
  end

  def self.all_enabled(par = nil)
    if par.nil?
      scoped
    elsif par == 'true'
      where(:deleted_at => nil)
    else    par == 'false'
           where("deleted_at IS NOT NULL")
    end
  end
end
