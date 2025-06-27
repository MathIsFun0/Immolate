#ifndef SEARCH_HPP
#define SEARCH_HPP
#include <fstream>
#include "instance.hpp"
#include <atomic>
#include <functional>
#include <iostream>
#include <thread>

#include <atomic>
#include <functional>
#include <iostream>
#include <thread>
#include <vector>
#include <mutex>


const long long BLOCK_SIZE = 1000000;

class Search {
public:
    std::atomic<long long> seedsProcessed{0};
    std::atomic<long long> highScore{1};
    long long printDelay = 10000000;
    std::function<int(Instance)> filter;
    std::atomic<bool> found{false}; // Atomic flag to signal when a solution is found
    Seed foundSeed; // Store the found seed
    bool exitOnFind = false;
    bool saveToFile = true;
    long long startSeed = 0;
    int numThreads = 8;
    long long numSeeds = 2318107019761;
    std::mutex mtx;
    std::atomic<long long> nextBlock{0}; // Shared index for the next block to be processed

    Search(std::function<int(Instance)> f) {
        filter = f;
    }

    Search(std::function<int(Instance)> f, int t) {
        filter = f;
        numThreads = t;
    }
    
    Search(std::function<int(Instance)> f, int t, long long n) {
      filter = f;
      numThreads = t;
      numSeeds = n;
    };
    Search(std::function<int(Instance)> f, std::string seed, int t, long long n) {
      filter = f;
      startSeed = Seed(seed).getID();
      numThreads = t;
      numSeeds = n;
    };

    void searchBlock(long long start, long long end) {
        Seed s = Seed(start);
        Instance inst(s);
        for (long long i = start; i < end; ++i) {
            if (found) return; // Exit if a solution is found
            // Perform the search on the seed
            int result = filter(inst);
            if (result >= highScore) {
                std::lock_guard<std::mutex> lock(mtx);
                highScore = result;
                foundSeed = s;
                if (saveToFile)
                {
                    std::ofstream seeds("seeds.txt", std::ios_base::app);
                    seeds << s.tostring() + "\n";
                    seeds.close();
                }
                std::cout << "Found seed: " << s.tostring() << " (" << result << ")"
                  << std::endl;
                if (exitOnFind) {
                    found = true;
                    return;
                }
            }
            seedsProcessed++;
            if (seedsProcessed % printDelay == 0) {
                std::cout << "Seeds processed: " << seedsProcessed << std::endl;
            }
            inst.next();
        }
    }

    std::string search() {
        if (saveToFile)
        {
            std::ofstream output("seeds.txt", std::ofstream::out | std::ofstream::trunc);
            output.close();
        }
        std::vector<std::thread> threads;
        long long totalBlocks = (numSeeds + BLOCK_SIZE - 1) / BLOCK_SIZE;
        for (int t = 0; t < numThreads; t++) {
            threads.emplace_back([this, totalBlocks]() {
                while (true) {
                    long long block = nextBlock.fetch_add(1);
                    if (block >= totalBlocks) break;
                    long long start = block * BLOCK_SIZE + startSeed;
                    long long end = std::min(start + BLOCK_SIZE, numSeeds + startSeed);
                    searchBlock(start, end);
                }
            });
        }

        for (auto& thread : threads) {
            thread.join();
        }

        return foundSeed.tostring();
    }
};

#endif