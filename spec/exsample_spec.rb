require 'spec_helper'

describe MyApp do

  it { should_not be_nil }

  it "should respond to /" do
    get '/'

    last_response.status.should == 200
    last_response.should be_ok
  end

end
