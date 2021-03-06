require 'spec_helper'

# Generators are not automatically loaded by Rails
require 'generators/rspec/controller/controller_generator'

describe Rspec::Generators::ControllerGenerator, :type => :generator do
  # Tell the generator where to put its output (what it thinks of as Rails.root)
  destination File.expand_path("../../../../../tmp", __FILE__)

  before { prepare_destination }

  describe 'controller specs' do
    subject { file('spec/controllers/posts_controller_spec.rb') }
    describe 'generated by default' do
      before do
        run_generator %w(posts)
      end

      describe 'the spec' do
        it { is_expected.to exist }
        it { is_expected.to contain(/require 'rails_helper'/) }
        it { is_expected.to contain(/^RSpec.describe PostsController, #{type_metatag(:controller)}/) }
      end
    end
    describe 'skipped with a flag' do
      before do
        run_generator %w(posts --no-controller_specs)
      end
      it { is_expected.not_to exist }
    end
  end

  describe 'view specs' do
    describe 'are not generated' do
      describe 'with no-view-spec flag' do
        before do
          run_generator %w(posts index show --no-view-specs)
        end
        describe 'index.html.erb' do
          subject { file('spec/views/posts/index.html.erb_spec.rb') }
          it { is_expected.not_to exist }
        end
      end
      describe 'with no actions' do
        before do
          run_generator %w(posts)
        end
        describe 'index.html.erb' do
          subject { file('spec/views/posts/index.html.erb_spec.rb') }
          it { is_expected.not_to exist }
        end
      end

      describe 'with --no-template-engine' do
        before do
          run_generator %w(posts index --no-template-engine)
        end

        describe 'index.html.erb' do
          subject { file('spec/views/posts/index.html._spec.rb') }
          it { is_expected.not_to exist }
        end
      end
    end

    describe 'are generated' do
      describe 'with default template engine' do
        before do
          run_generator %w(posts index show)
        end
        describe 'index.html.erb' do
          subject { file('spec/views/posts/index.html.erb_spec.rb') }
          it { is_expected.to exist }
          it { is_expected.to contain(/require 'rails_helper'/) }
          it { is_expected.to contain(/^RSpec.describe "posts\/index.html.erb", #{type_metatag(:view)}/) }
        end
        describe 'show.html.erb' do
          subject { file('spec/views/posts/show.html.erb_spec.rb') }
          it { is_expected.to exist }
          it { is_expected.to contain(/require 'rails_helper'/) }
          it { is_expected.to contain(/^RSpec.describe "posts\/show.html.erb", #{type_metatag(:view)}/) }
        end
      end
      describe 'with haml' do
        before do
          run_generator %w(posts index --template_engine haml)
        end
        describe 'index.html.haml' do
          subject { file('spec/views/posts/index.html.haml_spec.rb') }
          it { is_expected.to exist }
          it { is_expected.to contain(/require 'rails_helper'/) }
          it { is_expected.to contain(/^RSpec.describe "posts\/index.html.haml", #{type_metatag(:view)}/) }
        end
      end
    end
  end
end
