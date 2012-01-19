require 'rspec'
require 'xtrn'
require File.dirname(__FILE__) + '/spec_helpers'
describe Xtrn::Directory do

  let(:config) do
    [
      { 
        'path' => 'foo',
        'type' => 'svn',
        'url' => 'svn://svnhost/path/to/project'
      }
    ]
  end

  let(:executor) {mock('executor')}

  subject { Xtrn::Directory.new(config, executor) }

  let(:svn) { Xtrn::SpecHelpers::SVNCommand.new }
  let(:credentials) {nil}

  context 'updating' do
    before do
      executor.should_receive(:exec) do |actual_svn_cmd|
        actual_svn_cmd.should == svn.cmd('info').args(config[0]['url']).to_s
        <<EOF
Ignore this one: Some value
Last Changed Rev: 12345
Some other stuff: Bobby
EOF
      end
    end

    shared_examples_for('svn with command') do |c|
      it "should #{c} the given svn directory path" do
        executor.should_receive(:exec) do |actual_svn_cmd|
          actual_svn_cmd.should == svn.cmd(command).args("-r12345 #{config[0]['url']} #{config[0]['path']}").to_s
        end

        subject.update!
      end

      context 'with username and password' do
        let(:credentials) {%w(testuser testpass).tap{|i|svn.credentials(*i)}}
        it 'should pass username and password to svn if given' do
          config[0]['username'] = credentials[0]
          config[0]['password'] = credentials[1]
          executor.should_receive(:exec) do |actual_svn_cmd|
            actual_svn_cmd.should == svn.cmd(command).args("-r12345 #{config[0]['url']} #{config[0]['path']}").to_s
          end
          subject.update!
        end
      end
    end


    context 'when checkout path does not exist' do

      before do
        File.should_receive(:"directory?").with(config[0]['path']).and_return(false)
      end
      let(:command) {'checkout'}
      include_examples('svn with command', 'checkout')

    end

    context 'when checkout path already exists' do

      before do
        File.should_receive(:"directory?").with(config[0]['path']).and_return(true)
      end

      let(:command) {'update'}
      include_examples('svn with command', 'update')

    end
  end

  context "gitignore" do
    it 'should add missing entry to gitignore' do
      original_gitignore =<<EOF
Some_entry
# A comment
Another_entry
EOF
      subject.updated_gitignore(original_gitignore).should == original_gitignore + config[0]['path']
    end


    it 'should not add duplicate entries to gitignore' do
      original_gitignore =<<EOF
Some_entry
#{config[0]['path']}
# A comment
Another_entry
EOF
      subject.updated_gitignore(original_gitignore).should == original_gitignore
    end
  end

end
