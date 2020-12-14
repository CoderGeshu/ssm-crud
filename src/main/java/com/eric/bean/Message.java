package com.eric.bean;

import java.util.HashMap;
import java.util.Map;

/**
 * @Date: 2020/8/20 11:17
 * @author: Eric
 */
public class Message {
    // 状态码，100-成功，200-失败
    private int code;
    // 提示信息
    private String msg;
    // 附加拓展信息
    private Map<String, Object> extend = new HashMap<String, Object>();

    public Message() {
    }

    public Message(int code, String msg) {
        this.code = code;
        this.msg = msg;
    }

    public static Message success() {
        return new Message(100, "执行成功");
    }

    public static Message failed() {
        return new Message(200, "执行失败");
    }

    // 实现 Message 的链式操作，类似于 StringBuilder 的 append 方法
    public Message add(String key, Object value) {
        this.getExtend().put(key, value);
        return this;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Map<String, Object> getExtend() {
        return extend;
    }

    public void setExtend(Map<String, Object> extend) {
        this.extend = extend;
    }
}
