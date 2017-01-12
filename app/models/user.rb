class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :following_relationships, class_name:  "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following_users, through: :following_relationships, source: :followed
  has_many :followed_relationships, class_name:  "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followed_users, through: :followed_relationships, source: :follower

  # through:で指定されるのがDB上の中間テーブル
  has_many :ownerships , foreign_key: "user_id", dependent: :destroy
  has_many :items ,through: :ownerships
  
  # ownershipsテーブルからtypeがWantであるものを取得
  has_many :wants, class_name: "Want", foreign_key: "user_id", dependent: :destroy
  # wantしたアイテムの一覧を取得できる
  has_many :want_items , through: :wants, source: :item

  # ownershipsテーブルからtypeがHaveであるものの一覧がhaves
  # haveしたアイテムの一覧がhave_itemsで取得可能
  # source: :itemとしている部分はthrough: :havesで指定した参照先のクラスHaveに宣言されている
  # belongs\to :itemのitemを取得することを意味
  has_many :haves, class_name: "Have", foreign_key: "user_id", dependent: :destroy
  has_many :have_items , through: :haves, source: :item
  
  

  # 他のユーザーをフォローする
  def follow(other_user)
    following_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    following_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following_users.include?(other_user)
  end

  ## TODO 実装
  # itemをhaveする
  def have(item)
    #binding.pry
    # あればfind, 無ければcreateする．連打とかされた時のエラー回収
    haves.find_or_create_by(item_id: item.id)
  end

  # itemのhaveを解除する
  def unhave(item)
    have = haves.find_by(item_id: item.id)
    have.destroy if have
  end

  # itemをhaveしている場合true、haveしていない場合falseを返す
  def have?(item)
    have_items.include?(item)
  end
  
  # itemをwantする
  def want(item)
    #binding.pry
    wants.find_or_create_by(item_id: item.id)
  end

  # itemのwantを解除する
  def unwant(item)
    want = wants.find_by(item_id: item.id)
    want.destroy if want
  end

  #	itemをwantしている場合true、wantしていない場合falseを返す
  def want?(item)
    want_items.include?(item)
  end
end
