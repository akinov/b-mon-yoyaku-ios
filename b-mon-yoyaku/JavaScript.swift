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
            // Submit
            jQuery('button[data-action=reserveByCourse]').first().prop('disabled', false).click();
        
            result = true;
        }
        result;
    """
    // 新規予約完了
    static let reserveComplete = """
        var $completeBtn = jQuery('button[data-action=reserveComplete]');
        var result = false;

        if ($completeBtn.length > 0 ) {
            // Submit
            $completeBtn.first().click();
            result = true;
        }
        result;
    """
    
    // バッグ移動
    static let move = """
        // 空いているサンドバッグ一覧を取得
        var $inputs = jQuery('.bag-check>input:not(:disabled)');
        var wishedBagId = [
            "21", "22", "23", "24", "25", "26", "27", // "28",
            "35", "36", "37", "38", "39", "40", "41", // "42",
            "48",       "49", "50", "51",       "52", // "53",
            "60", "61", "62", "63", "64", "65", "66", // "67",
            "74", "75", "76", "77", "78", "79", "80", // "81",
        ];

        if ($inputs.length > 0 ) {
            var id = null;
            $inputs.each(function(){
                if (wishedBagId.includes(jQuery(this).attr('id').slice(-2))) {
                    id = jQuery(this).attr('id').slice(-2);
                    return false;
                }
            });

            // 目的のバッグがない場合
            if (id != null) {
                // bagIdをinputに入れる
                jQuery('#your-reservation input[name=punchbag]').first().val(id);
                // Submit
                jQuery('#your-reservation button[data-action=reserveMove]').first().prop('disabled', false).click();

                result = true;
            }
        }

        result;
    """
}
