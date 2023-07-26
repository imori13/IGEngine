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
		:win(SDL_CreateWindow(title.c_str(), x, y, w, h, flags))
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
	gsl::not_null<SDL_Window*> win;
};

class Renderer : public IRenderer
{
public:
	Renderer(/* constructor parameters */)
	{
		// Initialize renderer...
	}
	~Renderer()
	{
		// Clean up renderer...
	}

	// Add methods as necessary...

private:
	// Add private members as necessary...
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
			std::make_unique<Window>("Hello SDL World", 100, 100, 640, 480, SDL_WINDOW_SHOWN),
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
