
# test the usual successful run
Tinytest.add 'test processFile', (test) ->

  # get the function registered with Plugin.registerSourceHandler
  processFile = Plugin.fn

  # create our mock CompileStep
  compileStep = Plugin.compileStep()

  # call our plugin function with our mock CompileStep
  processFile compileStep

  # test results
  test.equal compileStep?.readBuffer?, true, 'CompileStep.read() should be called'
  test.equal Result.passThrough.run, true, 'should create a new PassThrough'
  test.equal Result.passThrough.buffer, compileStep.readBuffer

  # test building browserify
  test.equal Result?.browserify?, true, 'must run browserify function'
  test.equal Result.browserify.array?, true, 'must have an array to browserify'
  test.equal Result.browserify.array?.length, 1, 'browserify gets [readable], length should be 1'
  test.equal Result.browserify.array[0]?.isTestPassThrough, true, 'should receive our test PassThrough'
  options = debug:true, basedir:'/full/path/to/app/packages/.npm/package'
  test.equal Result.browserify?.options, options

  # test bundling with browserify and reading its result
  test.equal Result.browserify?.bundle, true, 'must run browserify.bundle()'
  test.equal Result.browserify?.encoding, 'utf8'
  test.equal Result.browserify?.on?.event, 'data', 'must call bundle.on \'data\''
  test.equal Result.browserify?.once?.end?, true, 'must call bundle.once \'end\''
  test.equal Result.browserify?.once?.error?, true, 'must call bundle.once \'error\''

  # test what's given to CompileStep.addJavaScript
  test.equal compileStep?.js?, true, 'CompileStep should contain addJavaScript info'
  test.equal compileStep.js.path, 'file.browserify.js'
  test.equal compileStep.js.sourcePath, 'file.browserify.js'
  test.equal compileStep.js.data, 'test data'



# test an error in browserify
Tinytest.add 'test with browserify error', (test) ->

  # cause it to use the on error callback
  Result.errorWanted = true

  # get the function registered with Plugin.registerSourceHandler
  processFile = Plugin.fn

  # create our mock CompileStep
  compileStep = Plugin.compileStep()

  # call our plugin function with our mock CompileStep
  processFile compileStep

  # test results
  test.equal compileStep?.readBuffer?, true, 'CompileStep.read() should be called'
  test.equal Result.passThrough.run, true, 'should create a new PassThrough'
  test.equal Result.passThrough.buffer, compileStep.readBuffer

  # test building browserify
  test.equal Result?.browserify?, true, 'must run browserify function'
  test.equal Result.browserify.array?, true, 'must have an array to browserify'
  test.equal Result.browserify.array?.length, 1, 'browserify gets [readable], length should be 1'
  test.equal Result.browserify.array[0]?.isTestPassThrough, true, 'should receive our test PassThrough'
  options = debug:true, basedir:'/full/path/to/app/packages/.npm/package'
  test.equal Result.browserify?.options, options

  # test bundling with browserify and reading its result
  test.equal Result.browserify?.bundle, true, 'must run browserify.bundle()'
  test.equal Result.browserify?.encoding, 'utf8'
  test.equal Result.browserify?.on?.event, 'data', 'must call bundle.on \'data\''
  test.equal Result.browserify?.once?.end?, true, 'must call bundle.once \'end\''
  test.equal Result.browserify?.once?.error?, true, 'must call bundle.once \'error\''

  # test error received by CompileStep#error()
  test.equal Result?.errorReceived?, true, 'CompileStep should receive an error'
  test.equal Result.errorReceived.message, 'test error'

# TODO: test with 'bundle' in process.argv
# TODO: test with 'build' in process.argv
# TODO: test with 'build' in process.argv and --debug
