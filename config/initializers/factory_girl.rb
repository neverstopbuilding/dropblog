if defined? FactoryGirl
  Dir[Rails.root.join("spec/support/spec_helpers/*.rb")].each {|f| require f}
  FactoryGirl::SyntaxRunner.send(:include, FactoryHelpers)
end
