# -*- coding: utf-8 -*-
require 'ripl'
require 'yaml'

module Ripl::I18n
  class<<self
    attr_accessor :locales

    def locale; Ripl.config[:i18n_locale]; end

    def translate(str)
      (locales[locale] ||= {})[str] || "Translation missing: #{locale}.#{str}"
    end

    def load_file(file)
      YAML.load_file(file)
    rescue
      warn "Error while loading locale from #{file}:\n#{$!}"
    end

    def init
      load Dir["#{File.dirname(__FILE__)}/i18n/locales/*.yml"]
      internationalize
    end

    def load(*files)
      files.flatten.each do |file|
        lang = File.basename(file)[/^[a-zA-Z]+/]
        next if lang.nil? || lang.empty?
        locales[lang.to_sym] = load_file(file)
      end
    end

    def internationalize
      Ripl::Runner::OPTIONS.each { |opt, val| locales[:en][opt] = val[1] }
      Ripl::Runner::OPTIONS.instance_eval %[
        def [](v) [dup[v][0], Ripl::I18n.translate(v)] end
        def values() map {|k,v| [v[0], Ripl::I18n.translate(k)] } end
      ]
      [Ripl::Runner::MESSAGES, Ripl::Shell::MESSAGES].each do |obj|
        obj.each { |opt, val| locales[:en][opt] = val }
        obj.instance_eval %[def [](v) Ripl::I18n.translate(v) end]
      end
    end
  end
  self.locales = {}
end

Ripl.config[:i18n_locale] ||= :en
Ripl::I18n.init
