require 'spec_helper'

def prepare(file, remove: false)
  FileUtils.copy File.join(@resources, file), @file
end

describe Eucalypt::Whitelist do
  before(:all) do
    @resources = File.join __dir__, 'resources'
    @file      = File.join __dir__, 'whitelist'
  end
  after { File.delete @file }

  context "when whitelist doesn't exist" do
    before { Whitelist.new @file }

    it { expect(File).to exist @file }
  end
  context 'when whitelist exists' do
    let(:whitelist) { Whitelist.new @file }

    context 'and file is empty' do
      before { prepare 'empty' }
      let(:contents) { File.open @file, &:read }

      context '#initialize' do
        context 'default IPs' do
          it 'should exist' do
            ['::1', '0.0.0.0', '127.0.0.1'].each do |ip|
              expect(whitelist.include? ip).to be true
            end
          end
        end
      end
      context '#add' do
        context 'with one IP' do
          context '(new)' do
            before { whitelist.add '255.255.255.255' }

            it 'should exist' do
              expect(whitelist.include? '255.255.255.255').to be true
            end
          end
          context '(existing)' do
            before { whitelist.add '255.255.255.255', '255.255.255.255' }

            it 'should exist' do
              expect(whitelist.include? '255.255.255.255').to be true
            end
            it 'should exist once' do
              expect(File.readlines(@file).size).to eq 4
            end
          end
        end
        context 'with multiple IPs' do
          context '(new)' do
            before { whitelist.add '0.0.0.1', '0.0.0.2', '0.0.0.3' }

            it 'should exist' do
              ['0.0.0.1', '0.0.0.2', '0.0.0.3'].each do |ip|
                expect(whitelist.include? ip).to be true
              end
            end
          end
          context '(existing)' do
            before { whitelist.add '0.0.0.1', '0.0.0.2', '0.0.0.3', '0.0.0.1', '0.0.0.2', '0.0.0.3' }

            it 'should exist' do
              ['0.0.0.1', '0.0.0.2', '0.0.0.3'].each do |ip|
                expect(whitelist.include? ip).to be true
              end
            end
            it 'should exist once' do
              expect(File.readlines(@file).size).to eq 6
            end
          end
        end
      end
      context '#remove' do
        context 'with one IP' do
          context '(present)' do
            before { whitelist.remove '::1' }

            it 'should not exist' do
              expect(whitelist.include? '::1').to be false
            end
          end
          context '(not present)' do
            before { whitelist.remove '255.255.255.255' }

            it 'should retain file contents' do
              expect(File.open @file, &:read).to eq contents
            end
          end
        end
        context 'with multiple IPs' do
          context '(present)' do
            before { whitelist.remove '::1', '0.0.0.0', '127.0.0.1' }

            it 'should not exist' do
              ['::1', '0.0.0.0', '127.0.0.1'].each do |ip|
                expect(whitelist.include? ip).to be false
              end
            end
          end
          context '(not present)' do
            before { whitelist.remove '0.0.0.1', '0.0.0.2', '0.0.0.3' }

            it 'should retain file contents' do
              ['0.0.0.1', '0.0.0.2', '0.0.0.3'].each do |ip|
                expect(File.open @file, &:read).to eq contents
              end
            end
          end
        end
      end
    end
    context 'and file contains one newline character' do
      before { prepare 'newline' }
      let(:contents) { File.open @file, &:read }

      context '#initialize' do
        it 'should contain the newline character' do
          expect(contents).to eq "\n"
        end
      end
      context '#add' do
        context 'with one IP' do
          before { whitelist.add '255.255.255.255' }

          it 'should exist' do
            expect(whitelist.include? '255.255.255.255').to be true
          end
          it 'should not have a leading newline character' do
            expect(contents.first).not_to eq "\n"
          end
        end
        context 'with multiple IPs' do
          before { whitelist.add '0.0.0.1', '0.0.0.2', '0.0.0.3' }

          it 'should exist' do
            ['0.0.0.1', '0.0.0.2', '0.0.0.3'].each do |ip|
              expect(whitelist.include? ip).to be true
            end
          end
          it 'should not have a leading newline character' do
            expect(contents.first).not_to eq "\n"
          end
        end
      end
      context '#remove' do
        context 'with one IP' do
          before { whitelist.remove '::1' }

          it 'should not exist' do
            expect(whitelist.include? '::1').to be false
          end
          it 'should not have a leading newline character' do
            expect(contents.first).not_to eq "\n"
          end
        end
        context 'with multiple IPs' do
          before { whitelist.remove '::1', '0.0.0.0' }

          it 'should not exist' do
            ['::1', '0.0.0.0'].each do |ip|
              expect(whitelist.include? ip).to be false
            end
          end
          it 'should not have a leading newline character' do
            expect(contents.first).not_to eq "\n"
          end
        end
        context 'with all IPs' do
          before { whitelist.remove '::1', '0.0.0.0', '127.0.0.1' }

          it 'should not exist' do
            ['::1', '0.0.0.0', '127.0.0.1'].each do |ip|
              expect(whitelist.include? ip).to be false
            end
          end
          it 'should have a leading newline character' do
            expect(contents.first).to eq "\n"
          end
        end
      end
    end
    context 'and file contains multiple newline characters' do
      before { prepare 'newlines' }
    end
    context 'and file contains an unexpected character' do
      before { prepare 'unexpected' }
    end
    context 'and file contains multiple unexpected characters' do
      before { prepare 'unexpecteds' }
    end
  end
end