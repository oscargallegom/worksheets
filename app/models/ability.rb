class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities

    user ||= User.new # guest user (not logged in)

    can :read, [State, County, CropCategory, Crop]

    if user.role? :user_administrator
      can [:read, :update, :destroy], User
    end
    if user.role? :project_administrator
      can :manage, :all
    end
    if user.role? :basic_user
      # can :manage, [Project, Field]
      # can :read, Project
      # can :manage, Project do |project|
      #   project.try(:id) == 1
      # end
      can :manage, Farm, :owner_id => user.id
      can :manage, Field, :farm => {:owner_id => user.id}
      can :manage, Strip, :field => {:farm => {:owner_id => user.id}}
      can :manage, CropRotation, :strip => {:field => {:farm => {:owner_id => user.id}}}

      can :read, SoilTestLaboratory

    end


  end

end

