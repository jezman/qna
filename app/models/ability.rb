class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer, Comment], user_id: user.id
    can :destroy, [Question, Answer], user_id: user.id

    can :destroy, ActiveStorage::Attachment do |resource|
      user.author?(resource.record)
    end

    can :destroy, Link do |resource|
      user.author?(resource.linkable)
    end

    can :best, Answer do |resource|
      user.author?(resource.question)
    end

    can [:vote_up, :vote_down], [Question, Answer]
    cannot [:vote_up, :vote_down], [Question, Answer], user_id: user.id
    can :revoke, [Question, Answer] do |resource|
      resource.likes.find_by(user_id: user.id)
    end

    can :me, User, id: user.id
  end
end
