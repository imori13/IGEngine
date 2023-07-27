#include "pch.hpp"

class IInitializer
{
public:
	virtual ~IInitializer() = default;
};

class IWindow
{
public:
	virtual ~IWindow() = default;
	virtual gsl::not_null<SDL_Window*> get() const = 0;
};

class IRenderer
{
public:
	virtual ~IRenderer() = default;
};

class Initializer : public IInitializer
{
public:
	Initializer()
	{
		if(SDL_Init(SDL_INIT_VIDEO) != 0)
		{
			throw std::runtime_error("SDL_Init Error: " + std::string(SDL_GetError()));
		}
	}
	~Initializer()
	{
		SDL_Quit();
	}
};

class Window : public IWindow
{
public:
	Window(const std::string& title, int x, int y, int w, int h, uint32_t flags)
		:win(SDL_CreateWindow(title.c_str(), x, y, w, h, flags), SDL_DestroyWindow)
	{

	}
	~Window()
	{
		SDL_DestroyWindow(win.get());
	}

	gsl::not_null<SDL_Window*> get() const noexcept override
	{
		return win.get();
	}

private:
	gsl::unique_ptr<SDL_Window, decltype(&SDL_DestroyWindow)> win;
};

class Renderer : public IRenderer
{
public:
	Renderer(/* constructor parameters */)
	{
		const std::string appName = "Hello, Vulkan";

		std::vector<const char*> extensions;

		VkApplicationInfo appInfo
		{
			.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO,
			.pApplicationName = appName.c_str(),
			.pEngineName = appName.c_str(),
			.engineVersion = VK_MAKE_VERSION(1, 0, 0),
			.apiVersion = VK_API_VERSION_1_1,
		};

		/* レイヤー、検証レイヤーを有効 */
		std::array<const char*, 1> layers = { "VK_LAYER_LUNARG_standard_validation" };
		VkInstanceCreateInfo ci
		{
			.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
			.pApplicationInfo = &appInfo,
			.enabledLayerCount = gsl::narrow<uint32_t>(layers.size()),
			.ppEnabledLayerNames = layers.data(),
			.enabledExtensionCount = gsl::narrow<uint32_t>(extensions.size()),
			.ppEnabledExtensionNames = extensions.data(),
		};

		vkCreateInstance(&ci, nullptr, &m_instance);
	}
	~Renderer()
	{
		// Clean up renderer...
	}

	// Add methods as necessary...

private:
	VkInstance m_instance;
};

class GameEngine
{
public:
	GameEngine(
		std::unique_ptr<IInitializer> initializer,
		std::unique_ptr<IWindow> window,
		std::unique_ptr<IRenderer> renderer) noexcept
		: initializer(std::move(initializer))
		, window(std::move(window))
		, renderer(std::move(renderer))
	{
	}

	void Run() noexcept
	{
		SDL_Event event;
		bool running = true;

		while(running)
		{
			while(SDL_PollEvent(&event))
			{
				if(event.type == SDL_QUIT)
				{
					running = false;
				}
			}

			// レンダリング処理...
		}
	}

private:
	std::unique_ptr<IInitializer> initializer;
	std::unique_ptr<IWindow> window;
	std::unique_ptr<IRenderer> renderer;
	// VulkanInstanceも同様に変更します...
};

int main(int argc, char* argv[])
{
	try
	{
		GameEngine game(
			std::make_unique<Initializer>(),
			std::make_unique<Window>("Hello SDL World", 100, 100, 800, 450, SDL_WINDOW_SHOWN),
			std::make_unique<Renderer>());

		game.Run();
	}
	catch(const std::exception& e)
	{
		std::cerr << e.what() << std::endl;
		return 1;
	}
	return 0;
}
