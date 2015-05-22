require 'spec_helper'
require 'app/support/assets'

describe 'Assets' do
  let(:assets) { Assets.new('spec/fixtures') }

  describe 'finding asset files' do
    subject { assets.files }

    it 'finds non-erb asset files' do
      expect(subject).to include('spec/fixtures/nested/foo.html')
    end

    it 'finds erb asset files' do
      expect(subject).to include('spec/fixtures/bar.html.erb')
    end

    it 'finds all assets' do
      expect(subject.length).to be(2)
    end

  end

  describe 'finding output path for files' do

    it 'removes the source directory from the path' do
      path = 'spec/fixtures/nested/foo.html'
      expect(assets.output_path(path)).to eq 'nested/foo.html'
    end

    it 'removes the erb suffix when compiling erb' do
      expect(assets.output_path('spec/fixtures/bar.html.erb')).to eq 'bar.html'
    end

  end

  describe 'getting file content' do

    describe 'reading erb content' do
      let(:path) { 'spec/fixtures/bar.html.erb' }
      let(:content) { 'this is evaluated because this is an erb file' }
      it 'evals the erb file' do
        expect(assets.content(path).strip).to eq content
      end
    end

    describe 'reading static content' do
      let(:path) { 'spec/fixtures/nested/foo.html' }
      let(:content) { '<%= "not evaluated because this isnt an erb file" %>' }
      it 'does not eval the content' do
        expect(assets.content(path).strip).to eq content
      end
    end

  end

end
