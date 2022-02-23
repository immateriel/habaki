require 'mkmf'

CONFIG['warnflags'].gsub!(/-W.* /, '')

# flex -o src/katana.lex.c src/katana.l
# bison -dl src/katana.y -o src/katana.tab.c 

$srcs = %w{src/katana-parser/katana.tab.c src/katana-parser/foundation.c src/katana-parser/katana.lex.c
src/katana-parser/parser.c src/katana-parser/selector.c src/katana-parser/tokenizer.c
src/rb_katana.c
}

$INCFLAGS << " -I$(srcdir)/src"

# add folder, where compiler can search source files
$VPATH << "$(srcdir)/src"

extension_name = 'katana'
dir_config(extension_name)
create_makefile("#{extension_name}/#{extension_name}")