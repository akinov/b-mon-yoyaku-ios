//
//  JavaScript.swift
//  b-mon-yoyaku
//
//  Created by akinov on 2018/03/04.
//  Copyright © 2018年 akinov. All rights reserved.
//

import Foundation

struct JavaScript {
    // 新規予約
    static let reserve = """
        // 空いているサンドバッグ一覧を取得
        var $inputs = jQuery('.bag-check>input:not(:disabled)');
        var result = false;
    
        if ($inputs.length > 0 ) {
            var id = $inputs[0].id.slice(-2)
        
            // bagIdをinputに入れる
            jQuery('#your-reservation input[name=punchbag]').first().val(id);
            // 完了をbackgroundに通知
            chrome.runtime.sendMessage({greeting: "checkComplete"});
            // Submit
            jQuery('button[data-action=reserveByCourse]').first().prop('disabled', false).click();
        
            result = true;
        }
        result;
    """
}
