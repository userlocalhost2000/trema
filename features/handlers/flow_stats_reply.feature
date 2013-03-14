Feature: flow_stats_reply handlers

  'flow_stats_reply' ハンドラは、スイッチのフローテーブルが格納する
  フローエントリの情報を取得するためのハンドラです。この情報は次の
  データを含みます。

  * フローテーブルの ID
  * フローエントリのフロー定義
  * インストールされてからの時間
  * 当該フローエントリの優先度
  * タイムアウトの設定値
  * クッキー値
  * 当該フローエントリが処理したパケットの数
  * 当該フローエントリが処理したトラフィックのバイト数

  フローエントリの情報を取得するための典型的なコードは、次のようになります。

  1. コントローラはフローエントリの情報の取得対象となる
     フローエントリを絞り込む 'Match' オブジェクトを作成する
  2. コントローラは [1] で作成した Match オブジェクトを指定し、
     スイッチに対してフローエントリの情報を取得する
     'FlowStatsRequest' メッセージを送る。
  3. スイッチがこれに応答し、'FlowStatsReeply' メッセージを
     コントローラへ送る。
  4. コントローラの 'flow_stats_reply' ハンドラでこのメッセージを
     ハンドルし、フローエントリの情報を取得する。

  Scenario: flow_stats_reply handler
    Given a file named "flow-stats-reply-checker.rb" with:
    """
    class FlowStatsReplyChecker < Controller
      def switch_ready datapath_id
        # This is for getting a reply of ofp_flow_stats
        send_flow_mod_add datapath_id, :match => Match.new

        send_message datapath_id, FlowStatsRequest.new( :match => Match.new ) 
      end


      def flow_stats_reply datapath_id, message
        message.stats.each do | each |
          info "length : #{ each.length }"
          info "table_id : #{ each.table_id }"
          info "match : #{ each.match }"
          info "duration_sec : #{ each.duration_sec }"
          info "duration_nsec : #{ each.duration_nsec }"
          info "priority : #{ each.priority }"
          info "idle_timeout : #{ each.idle_timeout }"
          info "hard_timeout : #{ each.hard_timeout }"
          info "cookie : #{ each.cookie }"
          info "packet_count : #{ each.packet_count }"
          info "byte_count : #{ each.byte_count }"
          info "actions : #{ each.actions }"
        end
      end
    end
    """
    And a file named "sample.conf" with:
    """
    vswitch { datapath_id "0xabc" }
    """
    When I run `trema run ./flow-stats-reply-checker.rb -c sample.conf` interactively
    Then the output should contain "length : " within the timeout period
     And the output should contain "table_id : " within the timeout period
     And the output should contain "match : " within the timeout period
     And the output should contain "duration_sec : " within the timeout period
     And the output should contain "duration_nsec : " within the timeout period
     And the output should contain "priority : " within the timeout period
     And the output should contain "idle_timeout : " within the timeout period
     And the output should contain "hard_timeout : " within the timeout period
     And the output should contain "cookie : " within the timeout period
     And the output should contain "packet_count : " within the timeout period
     And the output should contain "byte_count : " within the timeout period
     And the output should contain "actions : " within the timeout period
