class AbUser
  include DataMapper::Resource

  property :id, Serial
  property :email, String
  property :name, String
  property :atoken, String, :length => 200
  property :atokenhash, String
end
