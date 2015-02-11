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

  it { should respond_to :price= }
  it { should respond_to :price }
  it { should respond_to :country_code= }
  it { should respond_to :country_code }
  it { should respond_to :sender= }
  it { should respond_to :sender }
  
  it { should respond_to :logger= }
  it { should respond_to :logger }

end
