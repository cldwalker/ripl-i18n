require 'ripl/i18n'
require 'bacon'
require 'bacon/bits'

module Helpers
  def capture_stderr(&block)
    original_stderr = $stderr
    $stderr = fake = StringIO.new
    begin
      yield
    ensure
      $stderr = original_stderr
    end
    fake.string
  end
end

Bacon::Context.send :include, Helpers

describe Ripl::I18n do
  before_all { Ripl::I18n.locales = {} }

  describe ".init" do
    describe "defines locales" do
      before do
        Ripl::I18n.locales = {}
        Ripl::I18n.init
      end

      it "by language" do
        Ripl::I18n.locales.keys.should.include? :en
        Ripl::I18n.locales.keys.should.include? :es
      end

      it "with the correct number of translations" do
        Ripl::I18n.locales.values.each {|e| e.size.should == 13 }
      end
    end

    # already redefined when required
    describe "redefines" do
      before_all { Ripl.config[:i18n_locale] = :es }

      it "Runner::OPTIONS#[]" do
        Ripl::Runner::OPTIONS['-f'].should == ["-f", "Para de cargar ~/.irbrc"]
      end

      it "Runner::OPTIONS#values" do
        Ripl::Runner::OPTIONS.values.sort_by {|a,b| a[1] <=> b[1] }[0][1].
          should =~ /^Configura/
      end

      it "Runner::MESSAGES#[]" do
        Ripl::Runner::MESSAGES['start'].should =~ /^argumentos/
      end

      it "Shell::MESSAGES#[]" do
        Ripl::Shell::MESSAGES['prompt'].should =~ /^Ocurri/
      end
      after_all { Ripl.config[:i18n_locale] = :en }
    end

    describe ".translate" do
      before_all { Ripl::I18n.init }
      it "returns translation missing message for missing translation" do
        Ripl::I18n.translate('blah').should == "Translation missing: en.blah"
      end

      it "handles locales that haven't been defined yet" do
        Ripl.config[:i18n_locale] = :zzz
        Ripl::I18n.translate('-f').should =~ /^Translation missing/
        Ripl.config[:i18n_locale] = :en
      end
    end

    describe ".load" do
      def fixture(name)
        File.dirname(__FILE__) +"/fixtures/#{name}.yml"
      end

      before { Ripl::I18n.locales = {} }

      it "prints warning for locale file with invalid syntax" do
        capture_stderr {
          Ripl::I18n.load(fixture('invalid_syntax'))
        }.should =~ /^Error while loading/
      end

      it "sets locale using basename of locale file" do
        Ripl::I18n.load fixture('rb')
        Ripl::I18n.locales[:rb].should == {'-f' => 'woah dudez' }
      end

      it "skips locale if invalid basename" do
        Ripl::I18n.load fixture('')
        Ripl::I18n.locales.should.be.empty
      end
    end
  end
end
