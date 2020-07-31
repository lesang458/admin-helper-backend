require 'rails_helper'

RSpec.describe Device, type: :model do
  it { should respond_to(:name) }
  it { should respond_to(:price) }
  it { should respond_to(:description) }

  it { should allow_value('valid name').for(:name) }
  it { should_not allow_value(' ').for(:name) }
  it { should_not allow_value('  ').for(:name) }

  it { should allow_value(1000).for(:price) }
  it { should_not allow_value(-1000).for(:price) }
  it { should_not allow_value(0).for(:price) }

  it { should allow_value('here is description').for(:description) }
end
