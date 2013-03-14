Feature: stats_reply handlers

  'stats_reply' ハンドラは、すスイッチの様々な情報を取得するためのハンドラです。
  'stats_reply' ハンドラによって取得できる情報は次のデータを含みます。

  * ハードウェア情報
  * フローテーブルの情報
  * フローエントリの情報
  * フローエントリの統計情報
  * スイッチの物理ポートの情報

  NOTE: 'stats_reply' ハンドラは将来のバージョンで利用できなくなる予定です。
        代わりに、コントローラは取得する情報毎に用意されたイベントハンドラ
       （特定タイプハンドラ）を利用します。

  これらの情報を取得するための典型的なコードを、それぞれ以下のシナリオに示します。

  Scenario: ハードウェア情報を取得する場合
    Given a file named "obsolete-stats-reply-checker-for-DescStatsRequest.rb" with:
    """
    class ObsoleteStatsReplyChecker < Controller
      def switch_ready datapath_id
        send_message datapath_id, DescStatsRequest.new 
      end


      def stats_reply datapath_id, message
        message.stats.each do | each |
          info "message : #{ each.class }"
        end
      end
    end
    """
    And a file named "sample.conf" with:
    """
    vswitch { datapath_id "0xabc" }
    """
    When I run `trema run ./obsolete-stats-reply-checker.rb -c sample.conf` interactively
    Then the output should contain "Warning: 'stats_reply' handler will be deprecated" within the timeout period
      And the output should contain "message : Trema::DescStatsReply" within the timeout period

  Scenario: フローテーブルの情報を取得する場合
    Given a file named "obsolete-stats-reply-checker-for-TableStatsRequest.rb" with:
    """
    class ObsoleteStatsReplyChecker < Controller
      def switch_ready datapath_id
        send_message datapath_id, TableStatsRequest.new 
      end


      def stats_reply datapath_id, message
        message.stats.each do | each |
          info "message : #{ each.class }"
        end
      end
    end
    """
    And a file named "sample.conf" with:
    """
    vswitch { datapath_id "0xabc" }
    """
    When I run `trema run ./obsolete-stats-reply-checker.rb -c sample.conf` interactively
    Then the output should contain "Warning: 'stats_reply' handler will be deprecated" within the timeout period
      And the output should contain "message : Trema::TableStatsReply" within the timeout period

  Scenario: フローエントリの情報を取得する場合
    Given a file named "obsolete-stats-reply-checker-for-FlowStatsRequest.rb" with:
    """
    class ObsoleteStatsReplyChecker < Controller
      def switch_ready datapath_id
        # This is for getting a reply of ofp_flow_stats
        send_flow_mod_add datapath_id, :match => Match.new
    
        send_message datapath_id, FlowStatsRequest.new( :match => Match.new ) 
      end


      def stats_reply datapath_id, message
        message.stats.each do | each |
          info "message : #{ each.class }"
        end
      end
    end
    """
    And a file named "sample.conf" with:
    """
    vswitch { datapath_id "0xabc" }
    """
    When I run `trema run ./obsolete-stats-reply-checker.rb -c sample.conf` interactively
    Then the output should contain "Warning: 'stats_reply' handler will be deprecated" within the timeout period
      And the output should contain "message : Trema::FlowStatsReply" within the timeout period

  Scenario: フローエントリの統計情報を取得する場合
    Given a file named "obsolete-stats-reply-checker-for-AggregateStatsRequest.rb" with:
    """
    class ObsoleteStatsReplyChecker < Controller
      def switch_ready datapath_id
        # This is for getting a reply of ofp_flow_stats
        send_flow_mod_add datapath_id, :match => Match.new
    
        send_message datapath_id, AggregateStatsRequest.new( :match => Match.new ) 
      end


      def stats_reply datapath_id, message
        message.stats.each do | each |
          info "message : #{ each.class }"
        end
      end
    end
    """
    And a file named "sample.conf" with:
    """
    vswitch { datapath_id "0xabc" }
    """
    When I run `trema run ./obsolete-stats-reply-checker.rb -c sample.conf` interactively
    Then the output should contain "Warning: 'stats_reply' handler will be deprecated" within the timeout period
      And the output should contain "message : Trema::AggregateStatsReply" within the timeout period

  Scenario: スイッチの物理ポートの情報を取得する場合
    Given a file named "obsolete-stats-reply-checker-for-PortStatsRequest.rb" with:
    """
    class ObsoleteStatsReplyChecker < Controller
      def switch_ready datapath_id
        send_message datapath_id, PortStatsRequest.new 
      end


      def stats_reply datapath_id, message
        message.stats.each do | each |
          info "message : #{ each.class }"
        end
      end
    end
    """
    And a file named "sample.conf" with:
    """
    vswitch { datapath_id "0xabc" }
    """
    When I run `trema run ./obsolete-stats-reply-checker.rb -c sample.conf` interactively
    Then the output should contain "Warning: 'stats_reply' handler will be deprecated" within the timeout period
      And the output should contain "message : Trema::PortStatsReply" within the timeout period

  Scenario: 'stats_reply' ハンドラと特定タイプハンドラの両方が定義されている場合
    Given a file named "hybrid-stats-reply-checker.rb" with:
    """
    class HybridStatsReplyChecker < Controller
      def switch_ready datapath_id
        send_message datapath_id, TableStatsRequest.new 
        send_message datapath_id, PortStatsRequest.new 
      end


      def port_stats_reply datapath_id, message
        info "[ port_stats_reply ]"
      end
    
    
      def stats_reply datapath_id, message
        info "[ stats_reply ]"
      end
    end
    """
    And a file named "sample.conf" with:
    """
    vswitch { datapath_id "0xabc" }
    """
    When I run `trema run ./hybrid-stats-reply-checker.rb -c sample.conf` interactively
    Then the output should contain "Warning: 'stats_reply' handler will be deprecated" within the timeout period
     And the output should contain "[ stats_reply ]" within the timeout period
     And the output should contain "[ stats_reply ]" within the timeout period
