<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../common/head.jspf"%>

<script>
    function ChatMessages__remove(id, btn) {
        //     $.post(
        //         `/usr/chat/deleteMessageAjax/\${id}`, // 주소, action
        //         {
        //             _method: "DELETE"
        //         },
        //         function(data) {
        //             if ( data.msg ) {
        //                 alert(data.msg);
        //             }
        //         },
        //         'json' // 받은 데이터를 json 으로 해석하겠다.
        //     );
        // }

        // _method로 가짜 DELETE 요청을 흉내내는 것을 그만 두고, 진짜 DELETE로 보냄
        $.ajax({
            url: `/usr/chat/deleteMessageAjax/\${id}`,
            type: 'DELETE',
            success: function (data) {
                if (data.msg) {
                    alert(data.msg);
                }

                $(btn).parent().remove();
            },
            dataType: 'json'
        });
    }

    function ChatMessageSave__submitForm(form) {
        form.body.value = form.body.value.trim();

        if ( form.body.value.length == 0 ) {
            form.body.focus();

            return false;
        }

        // fetch 방식이 아닌, jquery 방식
        $.post(
            '/usr/chat/writeMessageAjax/${room.id}', // 주소, action
            {
                body: form.body.value // 폼 내용, input name, value
            },
            function(data) { // 콜백 메서드, 통신이 완료된 후, 실행
                // data.resultCode
                // data.msg
            },
            'json' // 받은 데이터를 json 으로 해석하겠다.
        );

        form.body.value = '';
        form.body.focus();
    }
</script>

<script>
    let Chatmsg__lastId = 0;
    function Chatmsg__loadMore() {
        fetch(`/usr/chat/getMessages/${room.id}/?fromId=\${Chatmsg__lastId}`)
            .then(data => data.json())
            .then(responseData => {
                const messages = responseData.data;
                for ( const index in messages ) {
                    const message = messages[index];
                    const html = `
                    <li class="flex">
                        <span>메세지 \${message.id} :</span>
                        &nbsp;
                        <span>\${message.body}</span>
                        &nbsp;
                        <a onclick="if ( confirm('정말로 삭제하시겠습니까?') ) ChatMessages__remove(\${message.id}, this); return false;" class="px-3 cursor-pointer hover:underline hover:text-[red] mr-2">삭제</a>
                    </li>
                    `;
                    $('.chat-messages').append(html);
                }

                if ( messages.length > 0 ) {
                    Chatmsg__lastId = messages[messages.length - 1].id;
                }
                // ChatMessages__loadMore(); // 즉시 실행
                setTimeout(Chatmsg__loadMore, 3000); // ChatMessages__loadMore(); 를 3초 뒤에 수행

            });
    }
</script>

<section>
    <div class="container px-3 mx-auto">
        <h1 class="font-bold text-lg">채팅방</h1>

        <div>
            ${room.title}
        </div>

        <div>
            ${room.body}
        </div>



        <form onsubmit="ChatMessageSave__submitForm(this); return false;" method="POST" action="/usr/chat/writeMessage/${room.id}">
            <input autofocus name="body" type="text" placeholder="메세지를 입력해주세요." class="input input-bordered" />
            <button type="submit" value="" class="btn btn-outline btn-primary">
                작성
            </button>
        </form>

        <ul class="chat-messages mt-5">
            <!-- 이 부분에 동적으로(자바스크립트로) 엘리먼트를 만들어서 넣어준다. -->
            <!-- 필요한 데이터는 ajax로 불러온다. -->
            <!-- /usr/chat/getMessages/10 => JSON으로 채팅메세지 제공 -->
        </ul>
    </div>
</section>

<script>
    Chatmsg__loadMore();
</script>

<%@ include file="../common/foot.jspf"%>