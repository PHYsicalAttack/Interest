Lua 支持协程，也叫 协同式多线程。 一个协程在 Lua 中代表了一段独立的执行线程。 然而，与多线程系统中的线程的区别在于， 协程仅在显式调用一个让出（yield）函数时才挂起当前的执行。

调用函数 coroutine.create 可创建一个协程。 其唯一的参数是该协程的主函数。 create 函数只负责新建一个协程并返回其句柄 （一个 thread 类型的对象）； 而不会启动该协程。

调用 coroutine.resume 函数执行一个协程。 第一次调用 coroutine.resume 时，第一个参数应传入 coroutine.create 返回的线程对象，然后协程从其主函数的第一行开始执行。 传递给 coroutine.resume 的其他参数将作为协程主函数的参数传入。 协程启动之后，将一直运行到它终止或 让出。

协程的运行可能被两种方式终止： 正常途径是主函数返回 （显式返回或运行完最后一条指令）； 非正常途径是发生了一个未被捕获的错误。 对于正常结束， coroutine.resume 将返回 true， 并接上协程主函数的返回值。 当错误发生时， coroutine.resume 将返回 false 与错误消息。

通过调用 coroutine.yield 使协程暂停执行，让出执行权。 协程让出时，对应的最近 coroutine.resume 函数会立刻返回，即使该让出操作发生在内嵌函数调用中 （即不在主函数，但在主函数直接或间接调用的函数内部）。 在协程让出的情况下， coroutine.resume 也会返回 true， 并加上传给 coroutine.yield 的参数。 当下次重启同一个协程时， 协程会接着从让出点继续执行。 调用coroutine.yield 会返回任何传给 coroutine.resume 的第一个参数之外的其他参数。

与 coroutine.create 类似， coroutine.wrap 函数也会创建一个协程。 不同之处在于，它不返回协程本身，而是返回一个函数。 调用这个函数将启动该协程。 传递给该函数的任何参数均当作 coroutine.resume 的额外参数。 coroutine.wrap 返回 coroutine.resume 的所有返回值，除了第一个返回值（布尔型的错误码）。 和 coroutine.resume 不同， coroutine.wrap 不会捕获错误； 而是将任何错误都传播给调用者。

下面的代码展示了一个协程工作的范例：

     function foo (a)
       print("foo", a)
       return coroutine.yield(2*a)
     end
     
     co = coroutine.create(function (a,b)
           print("co-body", a, b)
           local r = foo(a+1)
           print("co-body", r)
           local r, s = coroutine.yield(a+b, a-b)
           print("co-body", r, s)
           return b, "end"
     end)
     
     print("main", coroutine.resume(co, 1, 10))
     print("main", coroutine.resume(co, "r"))
     print("main", coroutine.resume(co, "x", "y"))
     print("main", coroutine.resume(co, "x", "y"))
当你运行它，将产生下列输出：

     co-body 1       10
     foo     2
     main    true    4
     co-body r
     main    true    11      -9
     co-body x       y
     main    true    10      end
     main    false   cannot resume dead coroutine
你也可以通过 C API 来创建及操作协程： 参见函数 lua_newthread， lua_resume， 以及 lua_yield。


关于协程的操作作为基础库的一个子库， 被放在一个独立表 coroutine 中。 协程的介绍参见 §2.6 。

coroutine.create (f)

创建一个主体函数为 f 的新协程。 f 必须是一个 Lua 的函数。 返回这个新协程，它是一个类型为 "thread" 的对象。

coroutine.isyieldable ()

如果正在运行的协程可以让出，则返回真。

不在主线程中或不在一个无法让出的 C 函数中时，当前协程是可让出的。

coroutine.resume (co [, val1, ···])

开始或继续协程 co 的运行。 当你第一次延续一个协程，它会从主体函数处开始运行。 val1, ... 这些值会以参数形式传入主体函数。 如果该协程被让出，resume 会重新启动它； val1, ... 这些参数会作为让出点的返回值。

如果协程运行起来没有错误， resume 返回 true 加上传给 yield 的所有值 （当协程让出）， 或是主体函数的所有返回值（当协程中止）。 如果有任何错误发生， resume 返回 false 加错误消息。

coroutine.running ()

返回当前正在运行的协程加一个布尔量。 如果当前运行的协程是主线程，其为真。

coroutine.status (co)

以字符串形式返回协程 co 的状态： 当协程正在运行（它就是调用 status 的那个） ，返回 "running"； 如果协程调用 yield 挂起或是还没有开始运行，返回 "suspended"； 如果协程是活动的，都并不在运行（即它正在延续其它协程），返回 "normal"； 如果协程运行完主体函数或因错误停止，返回 "dead"。

coroutine.wrap (f)

创建一个主体函数为 f 的新协程。 f 必须是一个 Lua 的函数。 返回一个函数， 每次调用该函数都会延续该协程。 传给这个函数的参数都会作为 resume 的额外参数。 和 resume 返回相同的值， 只是没有第一个布尔量。 如果发生任何错误，抛出这个错误。

coroutine.yield (···)

挂起正在调用的协程的执行。 传递给 yield 的参数都会转为 resume 的额外返回值。
