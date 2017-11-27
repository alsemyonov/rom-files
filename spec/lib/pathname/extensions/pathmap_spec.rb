# frozen_string_literal: true

require 'pathname/extensions'

RSpec.describe Pathname do
  before { described_class.load_extensions :pathmap }

  it 'returns_self_with_no_args', :aggregate_failures do
    expect(Pathname('abc.rb').pathmap).to eq Pathname('abc.rb')
  end

  it 's_returns_file_separator', :aggregate_failures do
    sep = File::ALT_SEPARATOR || File::SEPARATOR
    expect(Pathname('abc.rb').pathmap('%s')).to eq Pathname(sep)
    expect(Pathname('').pathmap('%s')).to eq Pathname(sep)
    expect(Pathname('a/b').pathmap('%d%s%f')).to eq Pathname("a#{sep}b")
  end

  it 'f_returns_basename', :aggregate_failures do
    expect(Pathname('abc.rb').pathmap('%f')).to eq Pathname('abc.rb')
    expect(Pathname('this/is/a/dir/abc.rb').pathmap('%f')).to eq Pathname('abc.rb')
    expect(Pathname('/this/is/a/dir/abc.rb').pathmap('%f')).to eq Pathname('abc.rb')
  end

  it 'n_returns_basename_without_extension', :aggregate_failures do
    expect(Pathname('abc.rb').pathmap('%n')).to eq Pathname('abc')
    expect(Pathname('abc').pathmap('%n')).to eq Pathname('abc')
    expect(Pathname('this/is/a/dir/abc.rb').pathmap('%n')).to eq Pathname('abc')
    expect(Pathname('/this/is/a/dir/abc.rb').pathmap('%n')).to eq Pathname('abc')
    expect(Pathname('/this/is/a/dir/abc').pathmap('%n')).to eq Pathname('abc')
  end

  it 'd_returns_dirname', :aggregate_failures do
    expect(Pathname('abc.rb').pathmap('%d')).to eq Pathname('.')
    expect(Pathname('/abc').pathmap('%d')).to eq Pathname('/')
    expect(Pathname('this/is/a/dir/abc.rb').pathmap('%d')).to eq Pathname('this/is/a/dir')
    expect(Pathname('/this/is/a/dir/abc.rb').pathmap('%d')).to eq Pathname('/this/is/a/dir')
  end

  it '9d_returns_partial_dirname', :aggregate_failures do
    expect(Pathname('this/is/a/dir/abc.rb').pathmap('%2d')).to eq Pathname('this/is')
    expect(Pathname('this/is/a/dir/abc.rb').pathmap('%1d')).to eq Pathname('this')
    expect(Pathname('this/is/a/dir/abc.rb').pathmap('%0d')).to eq Pathname('.')
    expect(Pathname('this/is/a/dir/abc.rb').pathmap('%-1d')).to eq Pathname('dir')
    expect(Pathname('this/is/a/dir/abc.rb').pathmap('%-2d')).to eq Pathname('a/dir')
    expect(Pathname('this/is/a/dir/abc.rb').pathmap('%100d')).to eq Pathname('this/is/a/dir')
    expect(Pathname('this/is/a/dir/abc.rb').pathmap('%-100d')).to eq Pathname('this/is/a/dir')
  end

  it 'x_returns_extension', :aggregate_failures do
    expect(Pathname('abc').pathmap('%x')).to eq Pathname('')
    expect(Pathname('abc.rb').pathmap('%x')).to eq Pathname('.rb')
    expect(Pathname('abc.xyz.rb').pathmap('%x')).to eq Pathname('.rb')
    expect(Pathname('.depends').pathmap('%x')).to eq Pathname('')
    expect(Pathname('dir/.depends').pathmap('%x')).to eq Pathname('')
  end

  it 'x_returns_everything_but_extension', :aggregate_failures do
    expect(Pathname('abc').pathmap('%X')).to eq Pathname('abc')
    expect(Pathname('abc.rb').pathmap('%X')).to eq Pathname('abc')
    expect(Pathname('abc.xyz.rb').pathmap('%X')).to eq Pathname('abc.xyz')
    expect(Pathname('ab.xyz.rb').pathmap('%X')).to eq Pathname('ab.xyz')
    expect(Pathname('a.xyz.rb').pathmap('%X')).to eq Pathname('a.xyz')
    expect(Pathname('abc.rb').pathmap('%X')).to eq Pathname('abc')
    expect(Pathname('ab.rb').pathmap('%X')).to eq Pathname('ab')
    expect(Pathname('a.rb').pathmap('%X')).to eq Pathname('a')
    expect(Pathname('.depends').pathmap('%X')).to eq Pathname('.depends')
    expect(Pathname('a/dir/.depends').pathmap('%X')).to eq Pathname('a/dir/.depends')
    expect(Pathname('/.depends').pathmap('%X')).to eq Pathname('/.depends')
  end

  it 'p_returns_entire_pathname', :aggregate_failures do
    expect(Pathname('abc.rb').pathmap('%p')).to eq Pathname('abc.rb')
    expect(Pathname('this/is/a/dir/abc.rb').pathmap('%p')).to eq Pathname('this/is/a/dir/abc.rb')
    expect(Pathname('/this/is/a/dir/abc.rb').pathmap('%p')).to eq Pathname('/this/is/a/dir/abc.rb')
  end

  it 'dash_returns_empty_string', :aggregate_failures do
    expect(Pathname('abc.rb').pathmap('%-')).to eq Pathname('')
    expect(Pathname('abc.rb').pathmap('%X%-%x')).to eq Pathname('abc.rb')
  end

  it 'percent_percent_returns_percent', :aggregate_failures do
    expect(Pathname('').pathmap('a%%b')).to eq Pathname('a%b')
  end

  it 'undefined_percent_causes_error', :aggregate_failures do
    expect { Pathname('dir/abc.rb').pathmap('%z') }.to raise_error ArgumentError
  end

  it 'pattern_returns_substitutions', :aggregate_failures do
    expect(Pathname('src/org/osb/Xyz.java').pathmap('%{src,bin}d')).to eq Pathname('bin/org/osb')
  end

  it 'pattern_can_use_backreferences', :aggregate_failures do
    expect(Pathname('dir/this/is').pathmap('%{t(hi)s,\\1}p')).to eq Pathname('dir/hi/is')
  end

  it 'pattern_with_star_replacement_string_uses_block', :aggregate_failures do
    expect(Pathname('src/org/osb/Xyz.java').pathmap('%{/org,*}d', &:upcase)).to eq Pathname('src/ORG/osb')
    expect(Pathname('src/org/osb/Xyz.java').pathmap('%{.*,*}f', &:capitalize)).to eq Pathname('Xyz.java')
  end

  it 'pattern_with_no_replacement_nor_block_substitutes_empty_string', :aggregate_failures do
    expect(Pathname('abc.rb').pathmap('%{a}f')).to eq Pathname('bc.rb')
  end

  it 'pattern_works_with_certain_valid_operators', :aggregate_failures do
    expect(Pathname('dir/abc.rb').pathmap('%{a,x}p')).to eq Pathname('dir/xbc.rb')
    expect(Pathname('dir/abc.rb').pathmap('%{i,1}d')).to eq Pathname('d1r')
    expect(Pathname('dir/abc.rb').pathmap('%{a,x}f')).to eq Pathname('xbc.rb')
    expect(Pathname('dir/abc.rb').pathmap('%{r,R}x')).to eq Pathname('.Rb')
    expect(Pathname('dir/abc.rb').pathmap('%{a,x}n')).to eq Pathname('xbc')
  end

  it 'multiple_patterns', :aggregate_failures do
    expect(Pathname('this/is/a/dir/abc.rb').pathmap('%{a,b;dir,\\0ectory}p')).to eq Pathname('this/is/b/directory/abc.rb')
  end

  it 'partial_directory_selection_works_with_patterns', :aggregate_failures do
    expect(Pathname('this/is/a/really/long/path/ok.rb').pathmap('%{/really/,/}5d')).to eq Pathname('this/is/a/long')
  end

  it 'pattern_with_invalid_operator', :aggregate_failures do
    expect do
      Pathname('abc.xyz').pathmap('%{src,bin}z')
    end.to raise_error ArgumentError, /unknown.*pathmap.*spec.*z/i
  end

  it 'works_with_windows_separators', :aggregate_failures do
    if File::ALT_SEPARATOR
      expect(Pathname('dir\abc.rb').pathmap('%n')).to eq Pathname('abc')
      expect(Pathname('this\is\a\dir\abc.rb').pathmap('%d')).to eq Pathname('this\is\a\dir')
    end
  end

  it 'complex_patterns', :aggregate_failures do
    sep = Pathname('').pathmap('%s')
    expect(Pathname('dir/abc.rb').pathmap('%d/%n%x')).to eq Pathname('dir/abc.rb')
    expect(Pathname('abc.rb').pathmap('%d/%n%x')).to eq Pathname('./abc.rb')
    expect(Pathname('dir/abc.rb').pathmap("Your file extension is '%x'")).to eq Pathname("Your file extension is '.rb'")
    expect(Pathname('src/org/onestepback/proj/A.java').pathmap('%{src,bin}d/%n.class')).to eq Pathname('bin/org/onestepback/proj/A.class')
    expect(Pathname('src_work/src/org/onestepback/proj/A.java').pathmap('%{\bsrc\b,bin}X.class')).to eq Pathname('src_work/bin/org/onestepback/proj/A.class')
    expect(Pathname('.depends').pathmap('%X.bak')).to eq Pathname('.depends.bak')
    expect(Pathname('a/b/c/d/file.txt').pathmap('%-1d%s%3d%s%f')).to eq Pathname("d#{sep}a/b/c#{sep}file.txt")
  end
end
