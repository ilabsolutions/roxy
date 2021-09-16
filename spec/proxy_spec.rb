require_relative 'abstract_spec'

describe "Proxy" do
  
  before(:each) do
    @owner = "String owner"
    @target = "String target"
    #yy@lambda_target = lambda { @target }
    @lambda_target = Proc.new{ @target }
  end

  it "should properly evaluate a block-based target" do
    proxy = Roxy::Proxy.new(@owner, {:to => @lambda_target}, nil)
    proxy.should == @target
  end
  
  it "should properly adorn the proxy with proxy methods" do
    proxy = Roxy::Proxy.new(@owner, {:to => @target}, nil) do
      def poop; 'poop'; end
    end
    proxy.poop.should == 'poop'
  end
  
  it "should make the proxy owner accessible to the target block" do
    proxy = Roxy::Proxy.new(@owner, {:to => proc { |owner| owner }}, nil)
    proxy.should == @owner
  end
    
end
