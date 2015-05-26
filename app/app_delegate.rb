class AppDelegate
  def applicationDidFinishLaunching(notification)
    @currentFaceIndex = 0
    @faces = loadFaces
    @statusBarItem = setupStatusBarItem
    setupHotKeys
  end

  def loadFaces
    faces_file = File.open(File.join(NSBundle.mainBundle.resourcePath, 'faces.yml')).read
    faces = YAML.load(faces_file)['faces']
    faces.uniq!.shuffle!
  end

  def setupStatusBarItem
    item = NSStatusBar.systemStatusBar.statusItemWithLength(-1)

    item.retain
    item.setTitle("(◕‿◕)")

    item.setHighlightMode(true)
    item.setMenu(setupMenu)

    item
  end

  def setupMenu
    menu = NSMenu.new
    menu.initWithTitle 'CoolFace'

    mi = NSMenuItem.new
    mi.title = 'About'
    mi.action = 'showAbout'
    menu.addItem mi

    mi = NSMenuItem.new
    mi.title = 'Quit'
    mi.action = 'terminate:'
    menu.addItem mi

    menu
  end

  def setupHotKeys
    center = DDHotKeyCenter.sharedHotKeyCenter
    center.registerHotKeyWithKeyCode(KVK_ANSI_C, modifierFlags:(NSCommandKeyMask|NSControlKeyMask|NSShiftKeyMask), target:self, action:'copyNextFace:', object:nil)
    center.registerHotKeyWithKeyCode(KVK_ANSI_X, modifierFlags:(NSCommandKeyMask|NSControlKeyMask|NSShiftKeyMask), target:self, action:'copyPrevFace:', object:nil)
  end

  def copyNextFace(event)
    @currentFaceIndex += 1

    if @currentFaceIndex > @faces.size - 1
      @currentFaceIndex = 0
    end

    copyFace
  end

  def copyPrevFace(event)
    @currentFaceIndex -= 1

    if @currentFaceIndex < 0
      @currentFaceIndex = @faces.size - 1
    end

    copyFace
  end

  def copyFace
    face = @faces[@currentFaceIndex].strip
    %x[printf "#{face}" | __CF_USER_TEXT_ENCODING=$UID:0x8000100:0x8000100 pbcopy]
    @statusBarItem.setTitle(face)
  end

  def showAbout
    unless @aboutWindow
      @aboutWindow = setupAboutWindow
      @aboutWindow.contentView.addSubview(setupTitleText)
      @aboutWindow.contentView.addSubview(setupVersionText)
      @aboutWindow.contentView.addSubview(setupInstructionsTextA)
      @aboutWindow.contentView.addSubview(setupInstructionsTextB)
      @aboutWindow.contentView.addSubview(setupCreditsText)
      @aboutWindow.contentView.addSubview(setupTransformationImage)
    end

    @aboutWindow.orderFrontRegardless
    NSApp.activateIgnoringOtherApps(true)
  end

  def setupAboutWindow
    width = 280
    height = 420
    left = NSScreen.mainScreen.frame.size.width/2 - width/2
    top = NSScreen.mainScreen.frame.size.height/2 - height/2

    window = NSPanel.alloc.initWithContentRect([[left, top], [width, height]],
      styleMask: NSTitledWindowMask|NSClosableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false
    )

    window
  end

  def setupTitleText
    text = setupTextField('CoolFace', :top => 70)
    text.font = NSFont.systemFontOfSize(30)
    text
  end

  def setupVersionText
    setupTextField("Version #{NSBundle.mainBundle.infoDictionary['CFBundleVersion']}", :top => 120)
  end

  def setupInstructionsTextA
    setupTextField("Next Cool Face: Cmd + Ctrl + Shift + C", :top => 160)
  end

  def setupInstructionsTextB
    setupTextField("Previous Cool Face: Cmd + Ctrl + Shift + X", :top => 180)
  end

  def setupCreditsText
    text = NSTextField.alloc.initWithFrame([[15, @aboutWindow.frame.size.height - 280], [@aboutWindow.frame.size.width - 30, 100]])
    text.backgroundColor = @aboutWindow.backgroundColor
    text.allowsEditingTextAttributes = true
    text.selectable = true
    text.editable = false
    text.bezeled = false

    credits = NSMutableAttributedString.alloc.init

    font = NSFont.systemFontOfSize(12)
    style = NSDictionary.dictionaryWithObject(font, forKey:NSFontAttributeName)

    credits.appendAttributedString(NSAttributedString.alloc.initWithString('Written by ', attributes:style))
    url = NSURL.URLWithString('http://twitter.com/uxtronaut')
    credits.appendAttributedString(NSAttributedString.hyperlinkFromString('@uxtronaut', withURL:url))

    credits.appendAttributedString(NSAttributedString.alloc.initWithString('. Icon by ', attributes:style))
    url = NSURL.URLWithString('http://twitter.com/benfrederick')
    credits.appendAttributedString(NSAttributedString.hyperlinkFromString('@benfrederick', withURL:url))

    credits.appendAttributedString(NSAttributedString.alloc.initWithString('. Cool hair animated graphic by Kole Kostelic', attributes:style))

    credits.appendAttributedString(NSAttributedString.alloc.initWithString('. Cool face curation assisted by Andy Mikulski', attributes:style))

    credits.appendAttributedString(NSAttributedString.alloc.initWithString('. Additional testing, ideas, and inspiration from the fine folks of ', attributes:style))
    url = NSURL.URLWithString('http://mondorobot.com')
    credits.appendAttributedString(NSAttributedString.hyperlinkFromString('Mondo Robot', withURL:url))

    credits.appendAttributedString(NSAttributedString.alloc.initWithString('.'))

    text.attributedStringValue = credits

    text
  end

  def setupTextField(value, options={})
    defaultOptions = {
      :alignment => NSCenterTextAlignment,
      :left => 0,
      :top => 0,
      :width => @aboutWindow.frame.size.width,
      :height => 35
    }

    options = defaultOptions.merge(options)

    options[:top] = @aboutWindow.frame.size.height - options[:top]

    text = NSTextField.alloc.initWithFrame([[options[:left], options[:top]], [options[:width], options[:height]]])
    text.stringValue = value
    text.alignment = options[:alignment]
    text.editable = false
    text.bezeled = false
    text.backgroundColor = @aboutWindow.backgroundColor

    text
  end

  def setupTransformationImage
    image = NSImage.alloc.initWithContentsOfFile(File.join(NSBundle.mainBundle.resourcePath, 'transformation.gif'))
    imageView = NSImageView.alloc.initWithFrame([[0, -25], [@aboutWindow.frame.size.width, 200]])
    imageView.image = image
    imageView.editable = false
    imageView
  end
end
