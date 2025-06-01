topLevel@{
  config,
  ...
}:
{
  flake.modules = {
    homeManager.dev =
      { pkgs, config, ... }:
      {
        home.packages = [
          pkgs.watchman
        ];
        programs = {
          jujutsu = {
            enable = true;
            settings = {
              core = {
                fsmonitor = "watchman";
                watchman.register-snapshot-trigger = true;
              };

              snapshot.max-new-file-size = "15M";

              user = {
                name = topLevel.config.flake.meta.users.${config.home.username}.name;
                email = topLevel.config.flake.meta.users.${config.home.username}.email;
              };

              ui = {
                default-command = "l";
                diff-editor = ":builtin";
                graph.style = "square";
                pager = ":builtin";
                show-cryptographic-signatures = true;
              };
              git = {
                private-commits = "description(glob:'wip:*') | description(glob:'private:*')";
                auto-local-bookmark = true;
                fetch = [
                  "origin"
                ];
                write-change-id-header = true;
              };
              revset-aliases = {
                "immutable_heads()" = "trunk() | tags() | remote_bookmarks(remote=origin)";
                "closest_bookmark(to)" = "heads(::to & bookmarks())";
                "closest_pushable(to)" =
                  "heads(::to & mutable() & ~description(exact:\"\") & (~empty() | merges()))";
                # Source: https://github.com/bryceberger/config/blob/38c6caf0823517b5423b2ca2a25f7fd79d445e0e/home/jj/config.toml
                "mine()" = "author(exact:'@name@') | author(exact:'@email@')";
                "wip()" = "description(glob:'wip:*')";
                "private()" = "description(glob:'private:*')";
                "stack()" = "ancestors(mutable() & (..@ | @::), 2)";
                "stack(x)" = "ancestors(mutable() & (..x | x::), 2)";
                "stack(x, n)" = "ancestors(mutable() & (..x | x::), n)";
                "streams()" = "heads(::@ & bookmarks())";
                "streams(x)" = "heads(::x & bookmarks())";
                "base_point(x)" = "heads(immutable_heads() & ::x)";
                "open()" = "stack(trunk().. & mine(), 2)";
                "open(n)" = "stack(trunk().. & mine(), n)";
                "why_immutable(r)" = "(r & immutable()) | roots(r:: & immutable_heads())";
              };
              revsets = {
                log = ''
                  none()
                    | base_point(@)
                    | ancestors(@, 10) & trunk()..@
                    | trunk()
                    | bookmarks()
                    | mutable() & visible_heads()
                    | fork_point(mutable() & visible_heads())
                    | (mutable() & merges())-
                '';
                short-prefixes = "stack(@)";
              };

              template-aliases = {
                "link(target, text)" =
                  ''raw_escape_sequence("\x1b]8;;" ++ target ++ "\x1b\\") ++ label("text link", text) ++ raw_escape_sequence("\x1b]8;;\x1b\\")'';
                "italic(text)" = ''raw_escape_sequence("\x1b[3m") ++ text ++ raw_escape_sequence("\x1b[23m")'';
                "dim(text)" = ''raw_escape_sequence("\x1b[2m") ++ text ++ raw_escape_sequence("\x1b[22m")'';

                "commit_description_verbose(commit)" = ''
                  concat(
                    commit_description(commit),
                    "JJ: ignore-rest\n",
                    diff.git(),
                  )
                '';
                "commit_description(commit)" = ''
                  concat(
                    commit.description(), "\n",
                    "JJ: This commit contains the following changes:\n",
                    indent("JJ:    ", diff.stat(72)),
                  )
                '';

                annotate_header = ''
                  if(first_line_in_hunk, surround("\n", "\n", separate("\n",
                    separate(" ",
                      format_short_change_id_with_hidden_and_divergent_info(commit),
                      format_short_id(commit.commit_id()),
                      format_short_cryptographic_signature(commit.signature()),
                      commit.description().first_line(),
                    ),
                    commit_timestamp(commit).local().format('%Y-%m-%d %H:%M:%S')
                      ++ " "
                      ++ commit.author(),
                  ))) ++ pad_start(4, line_number) ++ ": " ++ content
                '';

                # 00000000 ........ yyyy-mm-dd HH:MM:SS    1:
                annotate = ''
                  if(first_line_in_hunk,
                    separate(" ",
                      format_short_id(commit.change_id()),
                      pad_end(8, truncate_end(8, commit.author().email().local())),
                      commit_timestamp(commit).local().format('%Y-%m-%d %H:%M:%S'),
                    ),
                    pad_end(37, ""),
                  ) ++ pad_start(4, line_number) ++ ": " ++ content
                '';

                "format_commit_info(commit)" = ''
                  separate(" ",
                    format_short_change_id_with_hidden_and_divergent_info(commit),
                    format_short_id(commit.commit_id()),
                    format_short_cryptographic_signature(commit.signature()),
                  )'';

                "format_commit_bookmarks(commit)" = ''
                  separate(" ",
                    commit.working_copies(),
                    commit.tags(),
                    commit.bookmarks(),
                  )'';

                "format_description(commit)" = ''
                  separate(" ",
                    if(empty, label("empty", "(empty)")),
                    coalesce(
                      if(commit.description(),
                        truncate_end(48, commit.description().first_line(), " [...]"),
                        if(!empty, label("description placeholder", "(no description)")),
                      )
                    )
                  )'';

                "format_author(commit)" = ''
                  separate(" ",
                   commit.author().email(),
                   commit.author().name(),
                  )
                '';

                "format_commit_date(commit)" = ''
                  separate(" ",
                    commit_timestamp(commit).local().format('%Y-%m-%d %H:%M:%S'),
                  )
                '';

                default_log = ''
                  separate(" ",
                    format_commit_info(self),
                    format_commit_bookmarks(self),
                    format_description(self),
                    format_author(self),
                    format_commit_date(self),
                  )'';
              };

              templates = {
                draft_commit_description = "commit_description(self)";

                file_annotate = "annotate_header";

                log = "default_log";
                log_node = ''
                  label("node", coalesce(
                    if(!self, label("elided", "~")),
                    label(
                      separate(" ",
                        if(current_working_copy, "working_copy"),
                        if(conflict, "conflict"),
                        if(immutable, "immutable"),
                        if(description.starts_with("wip:"), "wip"),
                        if(description.starts_with("private:"), "wip"),
                      ),
                      coalesce(
                        if(current_working_copy, "@"),
                        if(conflict, "x"),
                        if(immutable, "◆"),
                        if(description.starts_with("wip:"), "!"),
                        if(description.starts_with("private:"), "◇"),
                        "○",
                      )
                    )
                  ))
                '';
              };

              aliases = {
                tug = [
                  "bookmark"
                  "move"
                  "--from"
                  "closest_bookmark(@)"
                  "--to"
                  "closest_pushable(@)"
                ];
                ds = [
                  "diff"
                  "--stat"
                ];
                dv = [
                  "--config=templates.draft_commit_description=commit_description_verbose(self)"
                  "describe"
                ];
                # Too slow - TODO investigate why
                # l = ["log" "-T" "builtin_log_compact"];
                # ll = ["log" "-T" "builtin_log_detailed"];
                l = [
                  "log"
                  "-r"
                  "all()"
                ];
                ll = [
                  "log"
                  "-r"
                  "all()"
                  "-T"
                  "builtin_log_detailed"
                ];
                xl = [
                  "log"
                  "-T"
                  "builtin_log_detailed"
                ];
                evolve = [
                  "rebase"
                  "--skip-empty"
                  "-d"
                  "main"
                ];
                streams = [
                  "log"
                  "--no-graph"
                  "-r"
                  "streams()"
                  "-T"
                  "bookmarks.map(|b| b ++ ' ')"
                ];
                open = [
                  "log"
                  "-r"
                  "open()"
                ];
                stack = [
                  "log"
                  "-r"
                  "stack()"
                ];
                s = [ "stack" ];
                yank = [
                  "rebase"
                  "--skip-emptied"
                  "-s"
                  "all:roots(mutable() & mine())"
                  "-d"
                  "trunk()"
                ];
              };
            };
          };
        };
      };
  };
}
