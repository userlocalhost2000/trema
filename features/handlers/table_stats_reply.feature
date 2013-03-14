Feature: table_stats_reply handlers

  'table_stats_reply' ハンドラは、スイッチのフローテーブルの情報を取得するためのハンドラです。
  フローテーブルの情報は次のデータを含みます。

  * フローテーブルの ID
  * 当該フローテーブルがサポートする "Wildcard" パラメータの種類
  * 当該フローテーブルが格納できるフローエントリの最大数
  * 当該フローテーブルにインストールされているフローエントリの数
  * 当該フローエントリを参照したパケットの数
  * 当該フローエントリが処理したパケットの数

  フローテーブルの情報を取得するための典型的なコードは、次のようになります。

  1. コントローラは、スイッチに対してフローテーブルの情報を取得する
     'TableStatsRequest' メッセージを送る。
  2. スイッチがこれに応答し、'TableStatsReply' メッセージをコントローラへ送る。
  3. コントローラの 'table_stats_reply' ハンドラでこのメッセージをハンドルし、
     フローテーブルの情報を取得する。

  Scenario: table_stats_reply handler
    Given a file named "table-stats-reply-checker.rb" with:
    """
    class TableStatsReplyChecker < Controller
      def switch_ready datapath_id
        send_message datapath_id, TableStatsRequest.new 
      end


      def table_stats_reply datapath_id, message
        message.stats.each do | each |
          info "table_id : #{ each.table_id }"
          info "name : #{ each.name }"
          info "wildcards : #{ each.wildcards }"
          info "max_entries : #{ each.max_entries }"
          info "active_count : #{ each.active_count }"
          info "lookup_count : #{ each.lookup_count }"
          info "matched_count : #{ each.matched_count }"
        end
      end
    end
    """
    And a file named "sample.conf" with:
    """
    vswitch { datapath_id "0xabc" }
    """
    When I run `trema run ./table-stats-reply-checker.rb -c sample.conf` interactively
    Then the output should contain "table_id : " within the timeout period
     And the output should contain "name : " within the timeout period
     And the output should contain "wildcards : " within the timeout period
     And the output should contain "max_entries : " within the timeout period
     And the output should contain "active_count : " within the timeout period
     And the output should contain "lookup_count : " within the timeout period
     And the output should contain "matched_count : " within the timeout period
