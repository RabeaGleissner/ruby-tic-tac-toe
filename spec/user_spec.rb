require 'spec_helper'
require 'user'
require 'pry-byebug'

describe User do
  let(:user) {User.new('Joe', 'x')}

  it 'has a name' do
    expect(user.name).to eq 'Joe'
  end

  it 'has a mark' do
    expect(user.mark).to eq 'x'
  end
end
