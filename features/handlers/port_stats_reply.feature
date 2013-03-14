Feature: port_stats_reply handlers

  'port_stats_reply' ハンドラは、スイッチの物理ポートの情報を取得するためのハンドラです。
  物理ポートの情報は次のデータを含みます。

  * 物理ポート番号
  * 送信したパケットの数
  * 受信したパケットの数
  * 送信したトラフィックのバイト数
  * 受信したトラフィックのバイト数
  * 送信したエラーパケットの数
  * 受信したエラーパケットの数
  * 受信したアライメントエラーフレームの数
  * 取りこぼしたパケットの数
  * 受信した CRC エラーのパケットの数
  * 衝突の回数

  物理ポートの情報を取得するための典型的なコードは、次のようになります。

  1. コントローラは、スイッチに対して物理ポートの情報を取得する
     'PortStatsRequest' メッセージを送る。
  2. スイッチがこれに応答し、'PortStatsReply' メッセージをコントローラへ送る。
  3. コントローラの 'port_stats_reply' ハンドラでこのメッセージをハンドルし、
     物理ポートの情報を取得する。

  Scenario: port_stats_reply handler
    Given a file named "port-stats-reply-checker.rb" with:
    """
    class PortStatsReplyChecker < Controller
      def switch_ready datapath_id
        send_message datapath_id, PortStatsRequest.new 
      end


      def port_stats_reply datapath_id, message
        message.stats.each do | each |
          info "port_no : #{ each.port_no }"
          info "rx_packets : #{ each.rx_packets }"
          info "tx_packets : #{ each.tx_packets }"
          info "rx_bytes : #{ each.rx_bytes }"
          info "tx_bytes : #{ each.tx_bytes }"
          info "rx_dropped : #{ each.rx_dropped }"
          info "tx_dropped : #{ each.tx_dropped }"
          info "rx_errors : #{ each.rx_errors }"
          info "tx_errors : #{ each.tx_errors }"
          info "rx_frame_err : #{ each.rx_frame_err }"
          info "rx_over_err : #{ each.rx_over_err }"
          info "rx_crc_err : #{ each.rx_crc_err }"
          info "collisions : #{ each.collisions }"
        end
      end
    end
    """
    And a file named "sample.conf" with:
    """
    vswitch { datapath_id "0xabc" }
    """
    When I run `trema run ./port-stats-reply-checker.rb -c sample.conf` interactively
    Then the output should contain "port_no : 65534" within the timeout period
     And the output should contain "rx_packets : " within the timeout period
     And the output should contain "tx_packets : " within the timeout period
     And the output should contain "rx_bytes : " within the timeout period
     And the output should contain "tx_bytes : " within the timeout period
     And the output should contain "rx_dropped : " within the timeout period
     And the output should contain "tx_dropped : " within the timeout period
     And the output should contain "rx_errors : " within the timeout period
     And the output should contain "tx_errors : " within the timeout period
     And the output should contain "rx_frame_err : " within the timeout period
     And the output should contain "rx_over_err : " within the timeout period
     And the output should contain "rx_crc_err : " within the timeout period
     And the output should contain "collisions : " within the timeout period
