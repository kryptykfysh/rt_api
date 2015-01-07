# encoding: utf-8

require 'spec_helper'

module RTApi
  RSpec.describe Connection do
    let(:connection) { RTApi::Connection.new }

    describe 'attributes' do
      specify { should respond_to :username }
      specify { should respond_to :password }
      specify { should respond_to :base_url }
    end

    describe 'methods' do
      describe '::new' do
        context 'when called with no parameters' do
          before do
            ENV['rt_api_user']  = 'gerald'
            ENV['rt_api_pass']  = 'wibble'
            ENV['rt_api_url']   = 'http://test.base.url/rt/'
          end

          [%w(user username), %w(pass password), %w(url base_url)].each do |env_var, attribute|
            it "should set @#{attribute} to environment variable rt_api_#{env_var}" do
              expect(connection.instance_variable_get("@#{attribute}"))
                .to eq(ENV["rt_api_#{env_var}"])
            end
          end
        end
      end

      describe '#rt_url' do

      end
    end
  end
end
