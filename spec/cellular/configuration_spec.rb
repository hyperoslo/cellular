require 'spec_helper'

describe Cellular::Configuration do

  it { should respond_to :username= }
  it { should respond_to :username }
  it { should respond_to :password= }
  it { should respond_to :password }
  it { should respond_to :delivery_url= }
  it { should respond_to :delivery_url }
  it { should respond_to :backend= }
  it { should respond_to :backend }

end
