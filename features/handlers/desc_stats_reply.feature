Feature: desc_stats_reply handlers

  'desc_stats_reply' ハンドラは、スイッチのハードウェア情報を取得するためのハンドラです。
  このハードウェア情報は次のデータを含みます。

  * 機器の情報
  * ハードウェアの情報
  * ソフトウェアの情報
  * スイッチの説明
  * シリアル番号

  ハードウェア情報を取得するための典型的なコードは、次のようになります。

  1. コントローラは、スイッチに対してハードウェア情報を取得する
     'DescStatsRequest' メッセージを送る。
  2. スイッチがこれに応答し、'DescStatsReply' メッセージをコントローラへ送る。
  3. コントローラの 'desc_stats_reply' ハンドラでこのメッセージをハンドルし、
     ハードウェア情報を取得する。

  Scenario: desc_stats_reply handler
    Given a file named "desc-stats-reply-checker.rb" with:
    """
    class DescStatsReplyChecker < Controller
      def switch_ready datapath_id
        send_message datapath_id, DescStatsRequest.new 
      end


      def desc_stats_reply datapath_id, message
        message.stats.each do | each |
          info "mfr_desc : #{ each.mfr_desc }"
          info "hw_desc : #{ each.hw_desc }"
          info "sw_desc : #{ each.sw_desc }"
          info "serial_num : #{ each.serial_num }"
          info "dp_desc : #{ each.dp_desc }"
        end
      end
    end
    """
    And a file named "sample.conf" with:
    """
    vswitch { datapath_id "0xabc" }
    """
    When I run `trema run ./desc-stats-reply-checker.rb -c sample.conf` interactively
    Then the output should contain "mfr_desc : " within the timeout period
     And the output should contain "hw_desc : " within the timeout period
     And the output should contain "sw_desc : " within the timeout period
     And the output should contain "serial_num : " within the timeout period
     And the output should contain "dp_desc : " within the timeout period

