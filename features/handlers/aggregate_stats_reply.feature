Feature: aggregate_stats_reply handlers

  `aggregate_stats_reply` ハンドラは、スイッチのフローテーブルが格納する
  統計情報を取得するためのハンドラです。この統計情報は次のデータ
  を含みます。

   * フローテーブル内にある指定したフロー定義に該当するフローエントリの数
   * 指定したフロー定義に該当するフローエントリが処理したパケットの数
   * 指定したフロー定義に該当するフローエントリが処理したトラフィックのバイト数

  統計情報を取得するための典型的なコードは、次のようになります:

   1. コントローラは統計情報の取得対象となるフローエントリを絞り込む
      'Match' オブジェクトを作成する
   2. コントローラは [1] で作成した Match オブジェクトを指定し、
   　 スイッチに対して統計情報を取得する
      `AggregateStatsRequest` メッセージを送る。
   3. スイッチがこれに応答し、`AggregateStatsReply` メッセージを
      コントローラへ送る
   4. コントローラの `aggregate_stats_reply` ハンドラでこのメッセージを
      ハンドルし、統計情報を取得する。

  Scenario: aggregate_stats_reply handler
    Given a file named "aggregate-stats-reply-checker.rb" with:
    """
    class AggregateStatsReplyChecker < Controller
      def switch_ready datapath_id
        send_flow_mod_add datapath_id, :match => Match.new

        send_message datapath_id, AggregateStatsRequest.new( :match => Match.new )
      end


      def aggregate_stats_reply datapath_id, message
        message.stats.each do | each |
          info "flow_count : #{ each.flow_count }"
          info "packet_count : #{ each.packet_count }"
          info "byte_count : #{ each.byte_count }"
        end
      end
    end
    """
    And a file named "sample.conf" with:
    """
    vswitch { datapath_id "0xabc" }
    """
    When I run `trema run ./aggregate-stats-reply-checker.rb -c sample.conf` interactively
    Then the output should contain "packet_count : " within the timeout period
     And the output should contain "byte_count : " within the timeout period
     And the output should contain "flow_count : " within the timeout period

