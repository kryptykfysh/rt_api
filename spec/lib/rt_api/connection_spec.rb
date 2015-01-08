# encoding: utf-8

require 'spec_helper'

module RTApi
  RSpec.describe Connection do
    before do
      ENV['rt_api_user']  = 'gerald'
      ENV['rt_api_pass']  = 'wibble'
      ENV['rt_api_url']   = 'http://test.base.url/rt'
      ENV['rt_api_path']  = '/WOMBLE/1.0/'
    end

    let(:connection) { RTApi::Connection.new }

    describe 'attributes' do
      specify { should respond_to :username }
      specify { should respond_to :password }
      specify { should respond_to :base_url }
      specify { should respond_to :path     }

      describe '@base_url' do
        context 'when argument has a trailing / character' do
          it 'should not have a trailing / character' do
            @conn = RTApi::Connection.new username: 'test', password: 'test', base_url: 'http://test/'
            expect(@conn.base_url).to eq('http://test')
          end
        end
      end
    end

    describe 'methods' do
      specify { should respond_to :full_path  }
      specify { should respond_to :valid?     }

      describe '::new' do
        context 'when called with no parameters' do
          [%w(user username), %w(pass password), %w(url base_url), %w(path path)].each do |env_var, attribute|
            it "should set @#{attribute} to environment variable rt_api_#{env_var}" do
              expect(connection.instance_variable_get("@#{attribute}"))
                .to eq(ENV["rt_api_#{env_var}"])
            end
          end
        end
      end

      describe '#full_path' do
        it 'should return a concatenation of @base_url and @path' do
          expect(connection.full_path).to eq(connection.base_url + connection.path)
        end
      end

      describe '#valid?' do
        context 'with correct connection information' do
          before do
            allow(RestClient::Request).to receive(:execute).and_return("RT/3.8.2 200 Ok\n\n# Invalid object specification: 'index.html'\n\nid: index.html\n\n")
          end

          it 'should return true' do
            expect(connection.valid?).to be true
          end
        end

        context 'with incorrect connection information' do
          it 'should return false' do
            expect(connection.valid?).to be false
          end
        end
      end
    end
  end
end
