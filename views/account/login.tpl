<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="utf-8">
    <link rel="shortcut icon" href="{{cdnimg "/static/favicon.ico"}}">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <meta name="renderer" content="webkit"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="author" content="MinDoc"/>
    <title>{{i18n .Lang "common.login"}} - Powered by MinDoc</title>
    <meta name="keywords"
          content="MinDoc,文档在线管理系统,WIKI,wiki,wiki在线,文档在线管理,接口文档在线管理,接口文档管理">
    <meta name="description" content="MinDoc文档在线管理系统 {{.site_description}}">
    <!-- Bootstrap -->
    <link href="{{cdncss "/static/bootstrap/css/bootstrap.min.css"}}" rel="stylesheet">
    <link href="{{cdncss "/static/font-awesome/css/font-awesome.min.css"}}" rel="stylesheet">
    <link href="{{cdncss "/static/css/main.css" "version"}}" rel="stylesheet">
    <style>
        .line {
            height: 0;
            border-top: 1px solid #cccccc;
            text-align: center;
            margin: 14px 0;
        }

        .line > .text {
            position: relative;
            top: -12px;
            background-color: #fff;
            padding: 5px;
        }

        .icon-box {
            align-items: center;
            justify-content: center;
            display: flex;
            display: -webkit-flex;
        }

        .icon {
            box-sizing: border-box;
            display: inline-block;
            padding: 10px;
            border-radius: 50%;
            cursor: pointer;
            margin: 0 5px;
        }

        .icon-disable {
            background-color: #cccccc;
            cursor: not-allowed;
        }

        .icon-disable:hover {
            background-color: #bbbbbb;
        }

        .icon > img {
            height: 24px;
        }
    </style>
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="{{cdnjs "/static/jquery/1.12.4/jquery.min.js"}}"></script>
</head>
<body class="manual-container">
<header class="navbar navbar-static-top smart-nav navbar-fixed-top manual-header" role="banner">
    <div class="container">
        <div class="navbar-header col-sm-12 col-md-6 col-lg-5">
            <a href="{{.BaseUrl}}" class="navbar-brand">{{.SITE_NAME}}</a>
        </div>
    </div>
</header>
<div class="container manual-body">
    <div class="row login">
        <div class="login-body">
            <form role="form" method="post">
                {{ .xsrfdata }}
                <h3 class="text-center">{{i18n .Lang "common.login"}}</h3>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">
                            <i class="fa fa-user"></i>
                        </div>
                        <input type="text" class="form-control"
                               placeholder="{{i18n .Lang "common.email"}} / {{i18n .Lang "common.username"}}"
                               name="account" id="account" autocomplete="off">
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">
                            <i class="fa fa-lock"></i>
                        </div>
                        <input type="password" class="form-control" placeholder="{{i18n .Lang "common.password"}}"
                               name="password" id="password" autocomplete="off">
                    </div>
                </div>
                {{if .ENABLED_CAPTCHA }}
                {{if ne .ENABLED_CAPTCHA "false"}}
                <div class="form-group">
                    <div class="input-group" style="float: left;width: 195px;">
                        <div class="input-group-addon">
                            <i class="fa fa-check-square"></i>
                        </div>
                        <input type="text" name="code" id="code" class="form-control" style="width: 150px" maxlength="5"
                               placeholder="{{i18n .Lang "common.captcha"}}" autocomplete="off">&nbsp;
                    </div>
                    <img id="captcha-img" style="width: 140px;height: 40px;display: inline-block;float: right"
                         src="{{urlfor "AccountController.Captcha"}}"
                         onclick="this.src='{{urlfor "AccountController.Captcha"}}?key=login&t='+(new Date()).getTime();"
                         title={{i18n .Lang "message.click_to_change"}}>
                    <div class="clearfix"></div>
                </div>
                {{end}}
                {{end}}
                <div class="checkbox">
                    <label>
                        <input type="checkbox" name="is_remember" value="yes"> {{i18n .Lang "common.keep_login"}}
                    </label>
                    <a href="{{urlfor "AccountController.FindPassword" }}"
                       style="display: inline-block;float: right">{{i18n .Lang "common.forgot_password"}}</a>
                </div>
                <div class="form-group">
                    <button type="button" id="btn-login" class="btn btn-success" style="width: 100%"
                            data-loading-text="{{i18n .Lang "common.logging_in"}}"
                            autocomplete="off">{{i18n .Lang "common.login"}}</button>
                </div>
                {{if .ENABLED_REGISTER}}
                {{if ne .ENABLED_REGISTER "false"}}
                <div class="form-group">
                    {{i18n .Lang "message.no_account_yet"}} <a href="{{urlfor "AccountController.Register" }}"
                                                               title={{i18n .Lang "common.register"}}>{{i18n .Lang "common.register"}}</a>
                </div>
                {{end}}
                {{end}}
                <div class="third-party">
                    <div class="line">
                        <span class="text">{{i18n .Lang "common.third_party_login"}}</span>
                    </div>
                    <div class="icon-box">
                        <div class="icon {{ if .CanLoginMaxKey }}btn-success{{else}}icon-disable{{end}}"
                             title="{{i18n .Lang "common.wecom_login"}}" data-url="{{ .maxkey_login_url }}">
                            <img alt="{{i18n .Lang "common.wecom_login"}}"
                                 src="data:image/png;base64,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">
                        </div>
                        <!--<div class="icon {{ if .CanLoginDingTalk }}btn-success{{else}}icon-disable{{end}}" title="{{i18n .Lang "common.dingtalk_login"}}" data-url="{{ .dingtalk_login_url }}">
                            <img alt="{{i18n .Lang "common.dingtalk_login"}}" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAAAXNSR0IArs4c6QAAA9hJREFUaEPNmVvoZ1MUxz/fPOBR8uJBya0QXmRqhsZtasq4xQMP7h5GyiR5MIkHlOQBDyaEcmvGrTBCYjDuKbmUW3jyQF7kEsrSd9pHx+9/fufss8/5/85v1e7/6/9ba+31OXutfdbeP9EgEfE6cChwN3CXpL+a9Jbhf2oBWJ+++wN42DCSvliGoOsx5ADU9R8zjKRXlwWkL0AV905gO7BD0p9TwswDuAG4NSOwrxPIdkmfZeiPrjIP4Fjg456z7TCMpGd62g1SbwSwx4h4DzihwLvBnV6G+a7AvpdJG8BW4JZe3v6v/HsN5OUBflpN2wCOBj4daeLdLvi0Kj+O5HOPm7kAKY2eAzaNOOHPgH3uGZL+Geq7C8AvM7+VV0O8gxnkeUlvlE7QCpBW4QrgYmBd6SQZdh8ATwFPSvo+Q/8/lU6ASjMizksgZ/SZoKfub4ZIIC/m2GYD1ECOAs5MY03OJIU6HwIPSLqvzb6rBo4A3MB9A3wOvAXslvR+Sq8TU5EbyLqrIR8BWyR5J1shnSsQEd8CBzfYurhdfIbyOBXYmMZhq0CyTtLbs35zAO4HXMg58mgqRgPdNDKMt92zSgAuAB7Pib5B5wfAUG7Dz01Qha7YJenk3gAp118BTi+deSS7OyVdVwrg4A0xpWyU9FIRQFqFmwemwBD4JyRdWLQL1Y0iYiqINdXWXbwClWFEXAVcCxwy5JH2sPWtyJZ5+p3baJNhRBwAHAfsm8Y+M3/3ArwD1Yfb876NoVtvP/25B6MigJm02h/wEdTDUNXnHg95rupWSbe1OSoGSPVwDnDMGJE2+PAlgZ++G7y5MgTAbUNWx1gIeJmkh7psiwHS1upj4vldkxR8/7Qkt++dMghglSB+AU6R5C60UwYDJIgx3w83Ssq+DRkFIEG4oO9oeT/8BPhK0nXj1GuSN4HTJP3d+eiTwmgACWI/YENq/KoXnS/IdlYHkogw5IqmLMWzSdILucFbb1SAnIkjwoegkxp0d82zb2qjK92FAkTEQcCXgN/cOfIrcHzb7xKLBvDW6FuHXLlI0iNtyosGuB24PjN6/yJ0TZfuogFeA1YcCxuCfEfS2q7gF1rEEXE4cGBDUN5W3dVW4rxfK+mTpQJoCiYiLgFm+53LJT2YE/xCV2AOgG/drqx9d68kH5iyZaE1MBtVRLhl9lWlJTvv634mA4iII9N1peNx3q/PbeCWBeBq4J4UzGZJ27LzpqY45Qo8C5wNbJO0uST4SYs4ItydfpVSJ7v7nAWdZAVST+Tr+g2S3i19+pOtQERcCuxdmveTF3FEeL8vzvs6wL8iyC9AZnHsagAAAABJRU5ErkJggg==">
                        </div>
                        <div class="icon {{ if .CanLoginWorkWeixin }}btn-success{{else}}icon-disable{{end}}" title="{{i18n .Lang "common.wecom_login"}}" data-url="{{ .workweixin_login_url }}">
                            <img alt="{{i18n .Lang "common.wecom_login"}}" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAAAXNSR0IArs4c6QAABE9JREFUaEPtmVvIpWMUx3//IkkYhgkXTBiFHEPjVCYXJscJMyOHMEUZN0NOuWEuJCPHhBnqk0MuhmYaoswFQoYoTAqNHBqH0IyRK9Jfa/e80/u93/vt5917v/vb31ez6m1fPOv0f9Z6nrWetcUMJ81w/xkIgO3DgTOBY4H9St8fwPfAD+l3o6T/hrFZPQOwfSFwMXBGcryJX/8CLwFvAgFmexOhJjyNASTHbwQuaqK4C8/PwDPAakm/DKgrn0K25wKPAIsGNVaRL4DcJyki1Bd1jYDt84ExYE5f2psJvQ8s6TcakwKwfTuwqpkPA3NtAxZI+qJXTbUAbJ8DvN2rshb4T5H0aS96JgCwfRTwdS9KWuY9UFJcw41oHADbewMbgIjAqGiDpEuaGq8CeBK4qanwEPlWSHqsif6dAGwfCsQh2reJ4JB5vgPmS/otZ6cM4C7g/pzAFK4vl/RUzl4ZQOz+cTmBKVx/VdLlOXsdACl9ovGaTrRd0v45hwoAZwHv5ZhHsD5L0o5udgsAV6ZucQQ+djU5T9KWJgCmwwF+AViTimg0d1GLfpW0qQmA61LTNqoIrJW0pB/jRQqdCnzcj4IWZDZLOj5dJvsApwOHAW9JilddVyoA7AX8CeyWExjC+kpJ9yYAH6SXXmHmaElfZVMoCX8GnDAEB3Mqo41+x/bVQJyDMq2TdGlTALEL9+SsDWG9ABAvvnUV/f8AR0jaOpndciU+GPgEOGQITtapjPy+W9LLKQNmRd4DcR7LdK2k57MAkpKpiMJK4MP4JP2V7M4HFsZZsB1ZsLg08YhrNNZqC1q1nR5mFOIwLpI07rFk+/o0NFgj6Y5ip20HiOWpHoxJWlYXhboX2Q2poLSZSTskRYp0yHZcm2enbynwmqSYNU0g20VWzJH0e5VhsjfxQ8CtLSJYJmnM9pHAw5XZUgy5TuvWMqRmMyYj8eA6Js2V3pW0vttU4nXgghZAbJIUxSl2vu6MNWqbbb8IXFXyp6O3G4DYrY1ADLYGoS2S5iUAMemovrezDxfbJwN104oFucFWvNCi0RuEduZ/zazpR+AkSTEXmpRs3wY8WGHYJml2DkDc0VcM4n2SvUXSoykKNwNPAF8CjwPfRCXOAIih8MISz0fA05KeywGI+zru6DZoD0lRWceRbadOOEBOuOttr0jX7OfA+phwSwoAHcoBiOnxQTXeB7ComnsCB6RvduV3MxDft0C0AlslvVEDoHAwClZEJhzspJTtE9OEcG2q2hMGXjkAsTtlioP0gKRQ2BrZXg3E6D4onI+UCTC7A+cW3WqdwRyA4tYIx6NSxoupdUr/9ESlDocL+htYWhe1sgM5APHAmNvP1LhXlLZfAS6ryD0rKTqDSanxPzS9OtQrv+1rgGrXuUrSnTMCQDq05bMQF8ViST/NGAAJRLQd53U7uI3PQK9pMAr+aXMG+gW/C0C/O9eW3K4ItLWT/eqZ8RH4H4Zge30AMjOdAAAAAElFTkSuQmCC">
                        </div>-->
                    </div>
                </div>
            </form>
        </div>
    </div>
    <div class="clearfix"></div>
</div>
{{template "widgets/footer.tpl" .}}
<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="{{cdnjs "/static/bootstrap/js/bootstrap.min.js"}}" type="text/javascript"></script>
<script src="{{cdnjs "/static/layer/layer.js"}}" type="text/javascript"></script>

<script type="text/javascript">
    $(document).ready(function () {
        $("#account,#password,#code").on('focus', function () {
            $(this).tooltip('destroy').parents('.form-group').removeClass('has-error');
        });

        $(document).keydown(function (e) {
            var event = document.all ? window.event : e;
            if (event.keyCode === 13) {
                $("#btn-login").click();
            }
        });

        $(".icon").on('click', function () {
            if ($(this).hasClass("icon-disable")) {
                return;
            }
            window.location.href = $(this).data("url");
        })

        $("#btn-login").on('click', function () {
            $(this).tooltip('destroy').parents('.form-group').removeClass('has-error');
            var $btn = $(this).button('loading');

            var account = $.trim($("#account").val());
            var password = $.trim($("#password").val());
            var code = $("#code").val();

            if (account === "") {
                $("#account").tooltip({
                    placement: "auto",
                    title: "{{i18n .Lang "message.account_empty"}}",
                    trigger: 'manual'
                })
                    .tooltip('show')
                    .parents('.form-group').addClass('has-error');
                $btn.button('reset');
                return false;
            } else if (password === "") {
                $("#password").tooltip({title: '{{i18n .Lang "message.password_empty"}}', trigger: 'manual'})
                    .tooltip('show')
                    .parents('.form-group').addClass('has-error');
                $btn.button('reset');
                return false;
            } else if (code !== undefined && code === "") {
                $("#code").tooltip({title: '{{i18n .Lang "message.captcha_empty"}}', trigger: 'manual'})
                    .tooltip('show')
                    .parents('.form-group').addClass('has-error');
                $btn.button('reset');
                return false;
            } else {
                $.ajax({
                    url: "{{urlfor "AccountController.Login" "url" .url}}",
                    data: $("form").serializeArray(),
                    dataType: "json",
                    type: "POST",
                    success: function (res) {
                        if (res.errcode !== 0) {
                            $("#captcha-img").click();
                            $("#code").val('');
                            layer.msg(res.message);
                            $btn.button('reset');
                        } else {
                            turl = res.data;
                            if (turl === "") {
                                turl = "/";
                            }
                            window.location = turl;
                        }
                    },
                    error: function () {
                        $("#captcha-img").click();
                        $("#code").val('');
                        layer.msg('{{i18n .Lang "message.system_error"}}');
                        $btn.button('reset');
                    }
                });
            }

            return false;
        });
    });
</script>
</body>
</html>
