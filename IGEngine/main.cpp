#include "pch.hpp"

class GameEngine
{
public:
	inline void Run()
	{
		if (SDL_Init(SDL_INIT_VIDEO) != 0)
		{
			throw std::runtime_error("SDL_Init Error: " + std::string(SDL_GetError()));
		}
		const auto sdlCleanup = gsl::finally([]() noexcept { SDL_Quit(); });

		const gsl::not_null<SDL_Window*> win = SDL_CreateWindow("Hello SDL World", 100, 100, 640, 480, SDL_WINDOW_SHOWN);
		const auto windowCleanup = gsl::finally([win]() noexcept { SDL_DestroyWindow(win); });

		const gsl::not_null<SDL_Renderer*> ren = SDL_CreateRenderer(win, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
		const auto rendererCleanup = gsl::finally([ren]() noexcept { SDL_DestroyRenderer(ren); });

		SDL_Event event;
		bool running = true;

		while (running)
		{
			while (SDL_PollEvent(&event))
			{
				if (event.type == SDL_QUIT)
				{
					running = false;
				}
			}

			SDL_SetRenderDrawColor(ren, 0, 0, 0, 255);
			SDL_RenderClear(ren);

			SDL_SetRenderDrawColor(ren, 255, 255, 255, 255);
			SDL_RenderPresent(ren);
		}
	}
};

int main(int argc, char* argv[])
{
	try
	{
		GameEngine game;
		game.Run();
	}
	catch (const std::exception& e)
	{
		std::cerr << e.what() << std::endl;
		return 1;
	}
	return 0;
}
