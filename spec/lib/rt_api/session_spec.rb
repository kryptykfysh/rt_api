# encoding: utf-8

require 'spec_helper'

module RTApi
  RSpec.describe Session do
    before do
      allow_any_instance_of(RTApi::Connection).to receive(:valid?).and_return(true)
    end

    let(:session) { RTApi::Session.new }

    describe 'attributes' do
      specify { should respond_to :connection }
    end

    describe 'methods' do
      describe '::new' do
        it 'should set @connection to an instance of RTApi::Connection' do
          expect(session.connection).to be_an_instance_of(RTApi::Connection)
        end

        context 'with invalid connection information' do
          before do
            allow_any_instance_of(RTApi::Connection).to receive(:valid?).and_return(false)
          end

          it 'should throw an RTApi::ConnectionError' do
            expect(RTApi::Session.new).to raise_error(RTApi::ConnectionError)
          end
        end
      end
    end
  end
end
