RSpec.describe Convict do
  it "has a version number" do
    expect(Convict::VERSION).not_to be nil
  end

  it "runs" do
    jail = Convict::Jail.new "spec/tests/simple/simple.rb"
    jail.run
  end
end
